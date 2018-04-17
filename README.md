# SHRuntime
Hook代码

### 针对不太方便去直接继承，但又希望重写某些方法的情况，对本例来讲
1.  生成一个新的类，为UIWindow类添加新的sendEvent方法名字叫sendEventOriginal。

2.  将你希望重写的sendEvent方法用一个新的方法sendEventHooked替换。

3.  需要调用父类sendEvent时改用sendEventOriginal。

4.  在运行时self被UIWindow代替，所以在实例方法sendEventHooked中不能调用HookObject的属性。

### 分类本来是不支持添加属性的，但可以通过runtime来实现。    
1.  UIControl+ButtonClick中通过重写UIButton的sendAction:to:forEvent:，用一个延迟开关sh_ignoreEvent变量来控制button是否能响应事件，从而避免重复点击。
