TweenMax     = false    if TweenMax     is `undefined`
TimelineLite = false    if TimelineLite is `undefined`
TweenLite    = false    if TweenLite    is `undefined`

((window, TweenLite, TweenMax, TimelineLite) ->
    #///////////////////private-helpers-functions//////////////////////
    _merge = (obj1, obj2) ->
        for attrName of obj2
            obj1[attrName] = obj2[attrName]
        return

    _ucfirst = (string) ->
        #Makes The First Letter Uppercase
        string.charAt(0).toUpperCase() + string.slice(1)

    _detectMethod = () ->
        method = ""
        method = "to"                            if @_to
        method = "from"    + _ucfirst(method)    if @_from
        method = "stagger" + _ucfirst(method)    if @_stagger
        method = "add" if(method is "")
        @_from = @_stagger = @_to = false
        method

    _setStartAfter = () ->
        @_startAfter1 = @_startAfter2
    _setAnimator = (animator) ->
        @_animatorObj = animator

    _registerAnimation = () ->
        _applyConfig.call(@)
        method = _detectMethod.call(@)
        @_arr.push(@_staggerTime)   if @_staggerTime
        if @_startAfter1 is '__notSetYet__'
            @_startAfter1 = @_startAfter2
            delete @_startAfter2
        @_arr.push(@_startAfter1)  if @_startAfter1
        @_animationsArr.push [@._arr, method] if not @_disabled
        @_startAfter1 = '__notSetYet__'
        delete @_staggerTime

    _applyConfig = () ->
        index = 0
        index = 2    if(@_from or @_to)
        index = 3    if(@_from and @_to)

        _merge(@_arr[index], @_config)

    _startRegisteredAnimations = (config) ->
      # this is for the last animation in the timeline ( before .start() )
        animations = @_animationsArr
        animatorObj = @_animatorObj
        animatorObj = new TimelineLite(config) if animations.length > 1
        i = 0
        while i < animations.length
            inputArr   = animations[i][0]
            methodName = animations[i][1]
          #  console.log inputArr, i, methodName, animations.length, animatorObj
            tween = animatorObj[methodName].apply(animatorObj, inputArr)

            i++
        tween

    #/////////////////////////-Construct-//////////////////////////
    animator = (el,disabled) ->
        @_animatorObj = TweenLite
        @_arr = [el]
        @_disabled = disabled
        @_config = {}
        @_animationsArr = []
        return

    #//////////////////////////////////////////////////////////////
    animator::during = (duration) ->
        @_arr[1] = duration
        @

    animator::config = (configObj) ->
        _merge(@_config, configObj)

    animator::to = (propsObj) ->
        @_to = true
        index = 2
        index++    if @_from
        @_arr[index] = propsObj
        @

    animator::from = (propsObj) ->
        @_from = true
        @_arr[2] = propsObj
        @

    animator::set = (props) ->
        @_set = true
        @_arr[1] = props
        @

    animator::at = (sec) ->
        @_startAfter1 = @_startAfter2
        @_startAfter2 = sec
        @

    animator::atLabel = (label) ->
        @at(label)
        @

    animator::atSecond = (sec) ->
        @at(sec)
        @

    animator::cycle = (prop, values) ->
        index = 2
        index++    if @_from and @_to
        #_merge(@_arr[index], 'cycle' : {prop : values})
        @_arr[index]['cycle'] = {} if not @_arr[index]['cycle']
        @_arr[index]['cycle'][prop] = values
        @

    #/////////////////////////-Callbacks-//////////////////////
    animator::onUpdate = (onUpdateHandler) ->
        @_config.onUpdate = onUpdateHandler
        @

    animator::onComplete = (completeHandler, params) ->
        @_config.onComplete = completeHandler
        @_config.onCompleteParams = params
        @

    #//////////////////////////////////////////////////////////

    #//////////////////////////-Start()-///////////////////////
    animator::startNow = ->
        @start(0)

    animator::after = (sec) ->
        @start(sec)

    #////////////////////////////////////////////////////

    #/////////////////////-Repeat-/////////////////////
    animator::thenYoyoForever = (delaySec=0) ->
        @thenYoyo(-1, delaySec)
        @

    animator::thenYoyo = (n=-1, delaySec=0) ->
        @thenRepeat(n, delaySec, true)
        @

    animator::thenRepeat = (n, delaySec=0, yoyo=false) ->
        _setAnimator.call(@,TweenMax)
        @_config.repeat = n
        @repeatDelay(delaySec) if delaySec
        @_config.yoyo = yoyo if yoyo
        @

    animator::repeatDelay = (sec) ->
        @_config.repeatDelay = sec
        @

  #///////////////////////-easing-////////////////////////
    animator::easeIn = (easeObj) ->
        @ease(easeObj,'easeIn')
        @

    animator::easeInOut = (easeObj) ->
        @ease(easeObj,'easeInOut')
        @

    animator::easeOut = (easeObj) ->
        @ease(easeObj,'easeOut')
        @

    animator::ease = (easeObj,property) ->
        @_config.ease = easeObj[property]
        @

    #/////////////////////////////////////////////////
    animator::stagger = (stagger) ->
        _setAnimator.call(@,TweenMax)
        @_stagger = true
        @_tweenMax = true
        @_staggerTime = stagger
        @

    animator::wait = (pauseTime) ->
        startAfter = "+=" + pauseTime if pauseTime > 0
        startAfter = "-=" + (pauseTime*-1) if pauseTime < 0
        @_startAfter1 = @_startAfter2
        @_startAfter2 = startAfter
        @

    animator::then = () ->
        @

    # This is executed in when animte is called in the middle of the chain.
    animator::animate = (el,disabled=false) ->
        _registerAnimation.call(@)
        @_disabled = true if disabled
        @_arr = [el]
        @

    animator::_animate = (el) ->
        @animate(el,true)

    # This is executed only when animte is called as the first function in the chain.
    _animate = (el) ->
        animate(el,true)

    # This is executed only when animte is called as the first function in the chain.
    animate = (el,disabled) ->
        new animator(el,disabled)

    animator::start = (delay, config) ->
        #@_startAfter1 = @_startAfter2
        _registerAnimation.call(@)
        _startRegisteredAnimations.call(@)

    animator::labelHereAs = (LabelStr) ->
        _registerAnimation.call(@)
        @_arr = [LabelStr]
        @


    # Exposing the animate() object to the global space.(while hiding the rest)
    window.animate = animate
    window._animate = _animate
    return
) window, TweenLite, TweenMax, TimelineLite
