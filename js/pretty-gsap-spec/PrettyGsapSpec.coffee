describe 'pretty-gsap', ->

  fromObj = left: '0px'

  beforeEach ->
  it 'should disable the animation by calling _animate', ->
    spyOn TweenLite, 'from'
    _animate('#el').during(111).from(left: '0px').start()
    expect(TweenLite.from).not.toHaveBeenCalledWith '#el', 111, {left: '0px'}

  it 'should be able to play an animation .from', ->
    spyOn TweenLite, 'from'
    animate('#el').during(111).from(left: '0px').start()

    expect(TweenLite.from).toHaveBeenCalledWith('#el', 111, {left: '0px'})

  it 'should be able to play an animation .to', ->
    spyOn TweenLite, 'to'
    animate('#el').during(111).to(left: '0px').start()
    expect(TweenLite.to).toHaveBeenCalledWith('#el', 111, {left: '0px'})

  it 'should be able to play an animation from to', ->
    spyOn TweenLite, 'fromTo'

    animate('#el').during(111).from(left: '0px').to(left: '100px').start()
    expect(TweenLite.fromTo).toHaveBeenCalledWith('#el' , 111 ,{left : '0px'},{left : '100px'})

  xit 'should be able to play an animation .to with a delay', ->
    spyOn TweenLite, 'to'
    animate('#el').during(111).to(left: '100px').delay(2).start()
    expect(TweenLite.to).toHaveBeenCalledWith '#el', 111,
      left: '100px'
      delay: 2

  describe 'ease options', ->
    Back = {easeInOut : 'easeInOut', easeIn : 'easeIn', easeOut : 'easeOut'}
    beforeEach ->
      spyOn TweenLite, 'from'

    it 'should be able to add easeInOut', ->
      animate('#el').during(111).from({left:'0px'}).easeInOut(Back).startNow()
      expect(TweenLite.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        ease: Back.easeInOut}

    it 'should be able to add easeOut', ->
      animate('#el').during(111).from({left:'0px'}).easeOut(Back).startNow()
      expect(TweenLite.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        ease: Back.easeOut}

    it 'should be able to add easeIn', ->
      animate('#el').during(111).from({left:'0px'}).easeIn(Back).startNow()
      expect(TweenLite.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        ease: Back.easeIn}


    it 'should be able to add passed ease on the "ease" Key.', ->
      console.log Back
      animate('#el').during(111).from({left:'0px'}).ease(Back,'easeIn').startNow()
      expect(TweenLite.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        ease: Back.easeIn}

    it 'should be able to add ease options on the second object when fromTo staggred animation is wanted.', ->
      spyOn TweenMax, 'staggerFromTo'
      animate('#el').during(111).from(left: '0px').to(left: '100px').stagger(333).easeIn(Back).startNow()

      expect(TweenMax.staggerFromTo).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        ease: Back.easeIn}
      ,
        {left: '100px'
        ease: Back.easeIn}
      , 333


  describe 'stagger options', ->
    _stagger_ = 3
    beforeEach ->
    it 'should be able to play an staggered from animation on TweenMax (not TweenLite)', ->
      spyOn TweenMax, 'staggerFrom'
      animate('#el').during(111).from(left: '0px').stagger(333).start()
      expect(TweenMax.staggerFrom).toHaveBeenCalledWith('#el', 111,{left: '0px'}, 333)

    it 'should be able to play a staggered from to animation on TweenMax (not TweenLite)', ->
      spyOn TweenMax, 'staggerFromTo'
      animate('#el').during(111).from({left: '0px'}).to({left: '100px'}).stagger(333).start()
      expect(TweenMax.staggerFromTo).toHaveBeenCalledWith('#el', 111, {left: '0px'} , {left: '100px'} , 333)

    it 'should be able to play a staggered to animation on TweenMax (not TweenLite)', ->
      spyOn TweenMax, 'staggerTo'
      animate('#el').during(111).to(left: '100px').stagger(333).start()
      expect(TweenMax.staggerTo).toHaveBeenCalledWith('#el', 111,{left: '100px'}, 333)


  describe 'Repeat features', ->
    beforeEach ->
      spyOn TweenMax, 'from'
      spyOn TweenLite, 'from'

    it 'should be able to play a repeated animation using TweenMax', ->
      animate('#el').during(111).from(left: '0px').thenRepeat(444).start()
      expect(TweenMax.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        repeat: 444}

      expect(TweenLite.from).not.toHaveBeenCalled()

    it 'should be able to play a repeated yoyo animation using TweenMax', ->
      animate('#el').during(111).from(left: '0px').thenYoyo(444).start()

      expect(TweenMax.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        repeat: 444
        yoyo: true}

      expect(TweenLite.from).not.toHaveBeenCalled()

    it 'should be able to play a repeated yoyo animation with delay using TweenMax', ->
      animate('#el').during(111).from(left: '0px').thenYoyo(444, 555).start()

      expect(TweenMax.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        repeat: 444
        repeatDelay: 555
        yoyo: true}

      expect(TweenLite.from).not.toHaveBeenCalled()

    it 'should be able to play a repeated  animation with delay using TweenMax', ->
      animate('#el').during(111).from(left: '0px').thenRepeat(444, 555).start()

      expect(TweenMax.from).toHaveBeenCalledWith '#el', 111,
        {left: '0px'
        repeat: 444
        repeatDelay: 555}

      expect(TweenLite.from).not.toHaveBeenCalled()

    it 'should be able to play animations on timelinelite', ->
      tl = new TimelineLite
      spyOn tl, 'from'
      #animate('#el').during(111).from({left: '0px'}).thenRepeat(444, 555).start()

      animate('#el').during(111).from({left: '0px'})
      .wait(2)
      .animate('#el2').during(1112).from({left: '1px'})
  #    .wait(1112)
	#		.labelHereAs('label_1')
	#		.atSecond(2).putLabel('hello')
			#.animate('#el2').during(2).from({left: '1px'})
    #  .atLabel('hello2').animate(tagline).during(0.3).stagger(0.1).from({left:"-=30px"})

      .start()

      expect(tl.from).toHaveBeenCalledWith '#el', 111, {left: '10px', ease: Power2.easeIn}
    	#	tl.from('#el', 111, {left:"0px", ease:Power2.easeIn});
      #	tl.add('label_1', '+=1112');
      #  tl.staggerFrom(tagline, 0.5, {top:"-=30px", rotation:"-40deg", alpha:0, scale:1.8, ease:Back.easeOut} , 0.2);




      #expect(TweenLite.from).not.toHaveBeenCalled()
# ---
