TweenMax = false    if TweenMax is `undefined`
TimelineLite = false    if TimelineLite is `undefined`
TweenLite = false    if TweenLite is `undefined`

#noinspection JSUnresolvedVariable
((window, TweenLite, TweenMax, TimelineLite) ->
#///////////////////private-helpers-functions//////////////////////
    _mergeObjs = (obj1, obj2) ->
        for attrName of obj2
            obj1[attrName] = obj2[attrName]
        return

    _ucfirst = (string) ->
#Makes The First Letter Uppercase
        string.charAt(0).toUpperCase() + string.slice(1)


    _setStartAfter = () ->
        @_currentAnimation.startAfter1 = @_currentAnimation.startAfter2

    _setGsapAnimator = (animator) ->
        @_gsapObj = animator

    _registerAnimation = () ->
        method = @_currentAnimation.methodName
        parameters = []
        parameters[0] = @_currentAnimation.el
        parameters[1] = @_currentAnimation.duration

        if(method == 'from')
            parameters[2] = @_currentAnimation.fromProps
            _mergeObjs(parameters[2], @_currentAnimation.config)

        if(method == 'to')
            parameters[2] = @_currentAnimation.toProps
            _mergeObjs(parameters[2], @_currentAnimation.config)

        if(method == 'fromTo')
            parameters[2] = @_currentAnimation.fromProps
            parameters[3] = @_currentAnimation.toProps
            _mergeObjs(parameters[3], @_currentAnimation.config)

        if(@_currentAnimation.staggerTime)
            method = 'stagger' + _ucfirst(method)
            _mergeObjs(parameters[2], @_currentAnimation.config)
            parameters.push(@_currentAnimation.staggerTime)

        if @_currentAnimation.startAfter1 is '__notSetYet__'
            @_currentAnimation.startAfter1 = @_currentAnimation.startAfter2
            delete @_currentAnimation.startAfter2
        parameters.push(@_currentAnimation.startAfter1)  if @_currentAnimation.startAfter1
        @_animationsQueue.push [parameters, method] if not @_currentAnimation.isDisabled
        @_currentAnimation.startAfter1 = '__notSetYet__'
        delete @_currentAnimation.staggerTime

    _startRegisteredAnimations = (config) ->
# this is for the last animation in the timeline ( before .start() )
        animations = @_animationsQueue
        animatorObj = @_gsapObj
        if animations.length > 1
            animatorObj = new TimelineLite(config)
        i = 0
        while i < animations.length
            inputArr = animations[i][0]
            methodName = animations[i][1]
            tween = animatorObj[methodName].apply(animatorObj, inputArr)
            i++
        tween

    PrettyGSAP = () ->
        @_gsapObj = TweenLite
        @_currentAnimation = {}
        @_currentAnimation.isDisabled = false
        @_currentAnimation.config = {}
        @_animationsQueue = []
        @

    PrettyGSAP::setElement = (element) ->
        @_currentAnimation.el = element
        @

    PrettyGSAP::during = (duration) ->
        @_currentAnimation.duration = duration
        @

    PrettyGSAP::disable = () ->
        @_currentAnimation.isDisabled = true
        @

    PrettyGSAP::config = (configObj) ->
        _mergeObjs(@_currentAnimation.config, configObj)

    PrettyGSAP::to = (propsObj) ->
        if @_currentAnimation.methodName == 'from'
            @_currentAnimation.methodName = 'fromTo' # appends 'To' to it.
        else
            @_currentAnimation.methodName = 'to'

        @_currentAnimation.toProps = propsObj
        @

    PrettyGSAP::from = (propsObj) ->
        @_currentAnimation.methodName = 'from'
        @_currentAnimation.fromProps = propsObj
        @

    PrettyGSAP::set = (props) ->
        @_currentAnimation.set = true
        @_currentAnimation.setProps = props
        @

    PrettyGSAP::at = (sec) ->
        @_currentAnimation.startAfter1 = @_currentAnimation.startAfter2
        @_currentAnimation.startAfter2 = sec
        @

    PrettyGSAP::atLabel = (label) ->
        @at(label)
        @

    PrettyGSAP::atSecond = (sec) ->
        @at(sec)
        @

    PrettyGSAP::cycle = (prop, values) ->
        index = 2
        index++    if @_currentAnimation.methodName == 'fromTo'
        #_mergeObjs(@_arr[index], 'cycle' : {prop : values})
        if not @_currentAnimation[index]['cycle']
            @_currentAnimation[index]['cycle'] = {}

        @_currentAnimation[index]['cycle'][prop] = values
        @

    #////////////////////-Callbacks-//////////////////////
    PrettyGSAP::onUpdate = (onUpdateHandler) ->
        @_currentAnimation.config.onUpdate = onUpdateHandler
        @

    PrettyGSAP::onComplete = (completeHandler, params) ->
        @_currentAnimation.config.onComplete = completeHandler
        @_currentAnimation.config.onCompleteParams = params
        @

    #/////////////////////-End-Callbacks-////////////////////////

    #///////////////////////-Start()-///////////////////////
    PrettyGSAP::startNow = ->
        @start(0)

    PrettyGSAP::after = (sec) ->
        @start(sec)

    #////////////////////////////////////////////////////

    #/////////////////////-Repeat-/////////////////////
    PrettyGSAP::thenYoyoForever = (delaySec = 0) ->
        @thenYoyo(-1, delaySec)
        @

    PrettyGSAP::thenYoyo = (n = -1, delaySec = 0) ->
        @thenRepeat(n, delaySec, true)
        @

    PrettyGSAP::thenRepeat = (n, delaySec = 0, yoyo = false) ->
        _setGsapAnimator.call(@, TweenMax)
        @_currentAnimation.config.repeat = n
        @repeatDelay(delaySec) if delaySec
        @_currentAnimation.config.yoyo = yoyo if yoyo
        @

    PrettyGSAP::repeatDelay = (sec) ->
        @_currentAnimation.config.repeatDelay = sec
        @

    #///////////////////////-easing-////////////////////////
    PrettyGSAP::easeIn = (easeObj) ->
        @ease(easeObj, 'easeIn')
        @

    PrettyGSAP::easeInOut = (easeObj) ->
        @ease(easeObj, 'easeInOut')
        @

    PrettyGSAP::easeOut = (easeObj) ->
        @ease(easeObj, 'easeOut')
        @

    PrettyGSAP::ease = (easeObj, property) ->
        @_currentAnimation.config.ease = easeObj[property]
        @

    #/////////////////////////////////////////////////
    PrettyGSAP::stagger = (stagger) ->
        _setGsapAnimator.call(@, TweenMax)
        @_tweenMax = true
        @_currentAnimation.staggerTime = stagger
        @

    PrettyGSAP::wait = (pauseTime) ->
        startAfter = "+=" + pauseTime if pauseTime > 0
        startAfter = "-=" + (pauseTime * -1) if pauseTime < 0
        @_currentAnimation.startAfter1 = @_currentAnimation.startAfter2
        @_currentAnimation.startAfter2 = startAfter
        @

    PrettyGSAP::then = () ->
        @

    # This is executed in when animte is called in the middle of the chain.
    PrettyGSAP::animate = (el, disabled = false) ->
        _registerAnimation.call(@)
        @_currentAnimation.isDisabled = true if disabled
        @_currentAnimation.el = el
        @

    PrettyGSAP::_animate = (el) ->
        @animate(el, true)

    # This is executed only when animate is called as the first function in the chain.
    # the user can disable the animation with putting an extra underscore for easier debug
    _animate = (el) ->
        animate(el, true)

    # This is executed only when animate is called as the first function in the chain.
    animate = (el, disabled) ->
        animator = new PrettyGSAP()
        animator.setElement(el)
        if disabled
            animator.disable()
        animator

    PrettyGSAP::start = (delay, config) ->
#@_animation.startAfter1 = @_animation.startAfter2
        _registerAnimation.call(@)
        _startRegisteredAnimations.call(@)

    PrettyGSAP::labelHereAs = (LabelStr) ->
        _registerAnimation.call(@)
        @_currentAnimation.label = LabelStr
        @


    # Exposing the animate() object to the global space.(while hiding the rest)
    window.animate = animate
    window._animate = _animate) window, TweenLite, TweenMax, TimelineLite
