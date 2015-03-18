

var GDU104X_INIT = func(Screen,mode)
{
    var myCanvas = canvas.new({
        "name": "Livery Test",   # The name is optional but allow for easier identification
        "size": [1024, 768]
        "view": [1024, 768]
        "mipmapping": 1
    });
    myCanvas.set("background", canvas.style.getColor("bg_color"));
    var root = myCanvas.createGroup();


    return root;
}
