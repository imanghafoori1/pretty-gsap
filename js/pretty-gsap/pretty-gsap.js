var TimelineLite, TweenLite, TweenMax;

if (TweenMax === undefined) {
  TweenMax = false;
}

if (TimelineLite === undefined) {
  TimelineLite = false;
}

if (TweenLite === undefined) {
  TweenLite = false;
}

(function(window, TweenLite, TweenMax, TimelineLite) {
  var _animate, _applyConfig, _detectMethod, _merge, _registerAnimation, _setAnimator, _setStartAfter, _startRegisteredAnimations, _ucfirst, animate, animator;
  _merge = function(obj1, obj2) {
    var attrName;
    for (attrName in obj2) {
      obj1[attrName] = obj2[attrName];
    }
  };
  _ucfirst = function(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  };
  _detectMethod = function() {
    var method;
    method = "";
    if (this._to) {
      method = "to";
    }
    if (this._from) {
      method = "from" + _ucfirst(method);
    }
    if (this._stagger) {
      method = "stagger" + _ucfirst(method);
    }
    if (method === "") {
      method = "add";
    }
    this._from = this._stagger = this._to = false;
    return method;
  };
  _setStartAfter = function() {
    return this._startAfter1 = this._startAfter2;
  };
  _setAnimator = function(animator) {
    return this._animatorObj = animator;
  };
  _registerAnimation = function() {
    var method;
    _applyConfig.call(this);
    method = _detectMethod.call(this);
    if (this._staggerTime) {
      this._arr.push(this._staggerTime);
    }
    if (this._startAfter1 === '__notSetYet__') {
      this._startAfter1 = this._startAfter2;
      delete this._startAfter2;
    }
    if (this._startAfter1) {
      this._arr.push(this._startAfter1);
    }
    if (!this._disabled) {
      this._animationsArr.push([this._arr, method]);
    }
    this._startAfter1 = '__notSetYet__';
    return delete this._staggerTime;
  };
  _applyConfig = function() {
    var index;
    index = 0;
    if (this._from || this._to) {
      index = 2;
    }
    if (this._from && this._to) {
      index = 3;
    }
    return _merge(this._arr[index], this._config);
  };
  _startRegisteredAnimations = function(config) {
    var animations, animatorObj, i, inputArr, methodName, tween;
    animations = this._animationsArr;
    animatorObj = this._animatorObj;
    if (animations.length > 1) {
      animatorObj = new TimelineLite(config);
    }
    i = 0;
    while (i < animations.length) {
      inputArr = animations[i][0];
      methodName = animations[i][1];
      tween = animatorObj[methodName].apply(animatorObj, inputArr);
      i++;
    }
    return tween;
  };
  animator = function(el, disabled) {
    this._animatorObj = TweenLite;
    this._arr = [el];
    this._disabled = disabled;
    this._config = {};
    this._animationsArr = [];
  };
  animator.prototype.during = function(duration) {
    this._arr[1] = duration;
    return this;
  };
  animator.prototype.config = function(configObj) {
    return _merge(this._config, configObj);
  };
  animator.prototype.to = function(propsObj) {
    var index;
    this._to = true;
    index = 2;
    if (this._from) {
      index++;
    }
    this._arr[index] = propsObj;
    return this;
  };
  animator.prototype.from = function(propsObj) {
    this._from = true;
    this._arr[2] = propsObj;
    return this;
  };
  animator.prototype.set = function(props) {
    this._set = true;
    this._arr[1] = props;
    return this;
  };
  animator.prototype.at = function(sec) {
    this._startAfter1 = this._startAfter2;
    this._startAfter2 = sec;
    return this;
  };
  animator.prototype.atLabel = function(label) {
    this.at(label);
    return this;
  };
  animator.prototype.atSecond = function(sec) {
    this.at(sec);
    return this;
  };
  animator.prototype.cycle = function(prop, values) {
    var index;
    index = 2;
    if (this._from && this._to) {
      index++;
    }
    if (!this._arr[index]['cycle']) {
      this._arr[index]['cycle'] = {};
    }
    this._arr[index]['cycle'][prop] = values;
    return this;
  };
  animator.prototype.onUpdate = function(onUpdateHandler) {
    this._config.onUpdate = onUpdateHandler;
    return this;
  };
  animator.prototype.onComplete = function(completeHandler, params) {
    this._config.onComplete = completeHandler;
    this._config.onCompleteParams = params;
    return this;
  };
  animator.prototype.startNow = function() {
    return this.start(0);
  };
  animator.prototype.after = function(sec) {
    return this.start(sec);
  };
  animator.prototype.thenYoyoForever = function(delaySec) {
    if (delaySec == null) {
      delaySec = 0;
    }
    this.thenYoyo(-1, delaySec);
    return this;
  };
  animator.prototype.thenYoyo = function(n, delaySec) {
    if (n == null) {
      n = -1;
    }
    if (delaySec == null) {
      delaySec = 0;
    }
    this.thenRepeat(n, delaySec, true);
    return this;
  };
  animator.prototype.thenRepeat = function(n, delaySec, yoyo) {
    if (delaySec == null) {
      delaySec = 0;
    }
    if (yoyo == null) {
      yoyo = false;
    }
    _setAnimator.call(this, TweenMax);
    this._config.repeat = n;
    if (delaySec) {
      this.repeatDelay(delaySec);
    }
    if (yoyo) {
      this._config.yoyo = yoyo;
    }
    return this;
  };
  animator.prototype.repeatDelay = function(sec) {
    this._config.repeatDelay = sec;
    return this;
  };
  animator.prototype.easeIn = function(easeObj) {
    this.ease(easeObj, 'easeIn');
    return this;
  };
  animator.prototype.easeInOut = function(easeObj) {
    this.ease(easeObj, 'easeInOut');
    return this;
  };
  animator.prototype.easeOut = function(easeObj) {
    this.ease(easeObj, 'easeOut');
    return this;
  };
  animator.prototype.ease = function(easeObj, property) {
    this._config.ease = easeObj[property];
    return this;
  };
  animator.prototype.stagger = function(stagger) {
    _setAnimator.call(this, TweenMax);
    this._stagger = true;
    this._tweenMax = true;
    this._staggerTime = stagger;
    return this;
  };
  animator.prototype.wait = function(pauseTime) {
    var startAfter;
    if (pauseTime > 0) {
      startAfter = "+=" + pauseTime;
    }
    if (pauseTime < 0) {
      startAfter = "-=" + (pauseTime * -1);
    }
    this._startAfter1 = this._startAfter2;
    this._startAfter2 = startAfter;
    return this;
  };
  animator.prototype.then = function() {
    return this;
  };
  animator.prototype.animate = function(el, disabled) {
    if (disabled == null) {
      disabled = false;
    }
    _registerAnimation.call(this);
    if (disabled) {
      this._disabled = true;
    }
    this._arr = [el];
    return this;
  };
  animator.prototype._animate = function(el) {
    return this.animate(el, true);
  };
  _animate = function(el) {
    return animate(el, true);
  };
  animate = function(el, disabled) {
    return new animator(el, disabled);
  };
  animator.prototype.start = function(delay, config) {
    _registerAnimation.call(this);
    return _startRegisteredAnimations.call(this);
  };
  animator.prototype.labelHereAs = function(LabelStr) {
    _registerAnimation.call(this);
    this._arr = [LabelStr];
    return this;
  };
  window.animate = animate;
  window._animate = _animate;
})(window, TweenLite, TweenMax, TimelineLite);
