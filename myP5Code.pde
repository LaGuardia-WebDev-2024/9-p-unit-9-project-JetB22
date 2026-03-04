setup = function() {
    size(600, 400);
};

//Background Images

//Variable Declarations

var d20 = round(random(1,20));
var d12 = round(random(1,12));
var d10 = round(random(1,10));
var d8 = round(random(1,8));
var d6 = round(random(1,6));
var d4 = round(random(1,4));



draw = function(){
//Scenes    
background(210,210,210);

//Dice    

textSize(40);
fill(0);

if(keyPressed) {
    d20 = round(random(1,20));
    if(key == '1'){
    text(d20,30,50);
    }

    if(key == '2'){
    d12 = round(random(1,12));
    text(d12,90,50);
    }

    if(key == '3'){
    d10 = round(random(1,10));
    text(d10,150,50);
    }

    if(key == '4'){
    d8 = round(random(1,8));
    text(d8,210,50);
    }

    if(key == '5'){
    d6 = round(random(1,6));
    text(d6,270,50);
    }

    if(key == '6'){
    d4 = round(random(1,4));
    text(d4,330,50);
    }
}



};
