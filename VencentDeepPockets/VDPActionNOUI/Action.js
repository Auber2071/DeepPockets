//
//  Action.js
//  VDPActionNOUI
//
//  Created by hankai on 2017/7/13.
//  Copyright © 2017年 Vencent. All rights reserved.
//  与Web也进行交互的脚本



var Action = function() {};

Action.prototype = {
    /**
     必须要有run和finalize方法，用作系统对JS的回调。
     */

    
    
    run: function(arguments) {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        // We will not modify anything, but will pass the body's background
        // style to the native code.
        
        /**
         在扩展激活后调用NSItemProvider的loadItemForTypeIdentifier方法时被调用（注：此时加载的Type为kUTTypePropertyList，因为一旦设置JS文件则能够检测到该类型的NSItemProvider），通过该方法的arguments参数的completionFunction方法可以给原生层传入一个数据对象。
         */
        
        arguments.completionFunction({ "currentBackgroundColor" : document.body.style.backgroundColor, "text" : window.getSelection().toString() });
    },
    
    finalize: function(arguments) {
        // This method is run after the native code completes.
        
        // We'll see if the native code has passed us a new background style,
        // and set it on the body.
        
        /**
         该方法的调用时机在扩展原生层调用completeRequestReturningItems后触发，这里有一个必要的触发条件，就是必须要扩展返回一个带有NSExtensionJavaScriptFinalizeArgumentKey的ExtensionItem，否则finalize方法不会执行。该方法能够通过arguments参数获取原生层返回的ExtensionItem包含在NSExtensionJavaScriptFinalizeArgumentKey中的内容。
         */
        
        var newBackgroundColor = arguments["newBackgroundColor"];
        if (newBackgroundColor) {
            // We'll set document.body.style.background, to override any
            // existing background.
            document.body.style.background = newBackgroundColor
        } else {
            // If nothing's been returned to us, we'll set the background to
            // blue.
            document.body.style.background= "purple"
        }
        
        
        alert(arguments["text"] + ":" + arguments["explain"]);

    }
    
};
    
var ExtensionPreprocessingJS = new Action
