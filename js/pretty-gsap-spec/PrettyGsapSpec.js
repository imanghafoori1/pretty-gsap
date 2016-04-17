describe('pretty-gsap', function() {
  var fromObj;
  fromObj = {
    left: '0px'
  };
  beforeEach(function() {});
  it('should disable the animation by calling _animate', function() {
    spyOn(TweenLite, 'from');
    _animate('#el').during(111).from({
      left: '0px'
    }).start();
    return expect(TweenLite.from).not.toHaveBeenCalledWith('#el', 111, {
      left: '0px'
    });
  });
  it('should be able to play an animation .from', function() {
    spyOn(TweenLite, 'from');
    animate('#el').during(111).from({
      left: '0px'
    }).start();
    return expect(TweenLite.from).toHaveBeenCalledWith('#el', 111, {
      left: '0px'
    });
  });
  it('should be able to play an animation .to', function() {
    spyOn(TweenLite, 'to');
    animate('#el').during(111).to({
      left: '0px'
    }).start();
    return expect(TweenLite.to).toHaveBeenCalledWith('#el', 111, {
      left: '0px'
    });
  });
  it('should be able to play an animation from to', function() {
    spyOn(TweenLite, 'fromTo');
    animate('#el').during(111).from({
      left: '0px'
    }).to({
      left: '100px'
    }).start();
    return expect(TweenLite.fromTo).toHaveBeenCalledWith('#el', 111, {
      left: '0px'
    }, {
      left: '100px'
    });
  });
  xit('should be able to play an animation .to with a delay', function() {
    spyOn(TweenLite, 'to');
    animate('#el').during(111).to({
      left: '100px'
    }).delay(2).start();
    return expect(TweenLite.to).toHaveBeenCalledWith('#el', 111, {
      left: '100px',
      delay: 2
    });
  });
  describe('ease options', function() {
    var Back;
    Back = {
      easeInOut: 'easeInOut',
      easeIn: 'easeIn',
      easeOut: 'easeOut'
    };
    beforeEach(function() {
      return spyOn(TweenLite, 'from');
    });
    it('should be able to add easeInOut', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).easeInOut(Back).startNow();
      return expect(TweenLite.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        ease: Back.easeInOut
      });
    });
    it('should be able to add easeOut', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).easeOut(Back).startNow();
      return expect(TweenLite.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        ease: Back.easeOut
      });
    });
    it('should be able to add easeIn', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).easeIn(Back).startNow();
      return expect(TweenLite.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        ease: Back.easeIn
      });
    });
    it('should be able to add passed ease on the "ease" Key.', function() {
      console.log(Back);
      animate('#el').during(111).from({
        left: '0px'
      }).ease(Back, 'easeIn').startNow();
      return expect(TweenLite.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        ease: Back.easeIn
      });
    });
    return it('should be able to add ease options on the second object when fromTo staggred animation is wanted.', function() {
      spyOn(TweenMax, 'staggerFromTo');
      animate('#el').during(111).from({
        left: '0px'
      }).to({
        left: '100px'
      }).stagger(333).easeIn(Back).startNow();
      return expect(TweenMax.staggerFromTo).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        ease: Back.easeIn
      }, {
        left: '100px',
        ease: Back.easeIn
      }, 333);
    });
  });
  describe('stagger options', function() {
    var _stagger_;
    _stagger_ = 3;
    beforeEach(function() {});
    it('should be able to play an staggered from animation on TweenMax (not TweenLite)', function() {
      spyOn(TweenMax, 'staggerFrom');
      animate('#el').during(111).from({
        left: '0px'
      }).stagger(333).start();
      return expect(TweenMax.staggerFrom).toHaveBeenCalledWith('#el', 111, {
        left: '0px'
      }, 333);
    });
    it('should be able to play a staggered from to animation on TweenMax (not TweenLite)', function() {
      spyOn(TweenMax, 'staggerFromTo');
      animate('#el').during(111).from({
        left: '0px'
      }).to({
        left: '100px'
      }).stagger(333).start();
      return expect(TweenMax.staggerFromTo).toHaveBeenCalledWith('#el', 111, {
        left: '0px'
      }, {
        left: '100px'
      }, 333);
    });
    return it('should be able to play a staggered to animation on TweenMax (not TweenLite)', function() {
      spyOn(TweenMax, 'staggerTo');
      animate('#el').during(111).to({
        left: '100px'
      }).stagger(333).start();
      return expect(TweenMax.staggerTo).toHaveBeenCalledWith('#el', 111, {
        left: '100px'
      }, 333);
    });
  });
  return describe('Repeat features', function() {
    beforeEach(function() {
      spyOn(TweenMax, 'from');
      return spyOn(TweenLite, 'from');
    });
    it('should be able to play a repeated animation using TweenMax', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).thenRepeat(444).start();
      expect(TweenMax.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        repeat: 444
      });
      return expect(TweenLite.from).not.toHaveBeenCalled();
    });
    it('should be able to play a repeated yoyo animation using TweenMax', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).thenYoyo(444).start();
      expect(TweenMax.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        repeat: 444,
        yoyo: true
      });
      return expect(TweenLite.from).not.toHaveBeenCalled();
    });
    it('should be able to play a repeated yoyo animation with delay using TweenMax', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).thenYoyo(444, 555).start();
      expect(TweenMax.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        repeat: 444,
        repeatDelay: 555,
        yoyo: true
      });
      return expect(TweenLite.from).not.toHaveBeenCalled();
    });
    it('should be able to play a repeated  animation with delay using TweenMax', function() {
      animate('#el').during(111).from({
        left: '0px'
      }).thenRepeat(444, 555).start();
      expect(TweenMax.from).toHaveBeenCalledWith('#el', 111, {
        left: '0px',
        repeat: 444,
        repeatDelay: 555
      });
      return expect(TweenLite.from).not.toHaveBeenCalled();
    });
    return it('should be able to play animations on timelinelite', function() {
      var tl;
      tl = new TimelineLite;
      spyOn(tl, 'from');
      animate('#el').during(111).from({
        left: '0px'
      }).wait(2).animate('#el2').during(1112).from({
        left: '1px'
      }).start();
      return expect(tl.from).toHaveBeenCalledWith('#el', 111, {
        left: '10px',
        ease: Power2.easeIn
      });
    });
  });
});
