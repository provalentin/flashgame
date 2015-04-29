package{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.text.TextField;

import Animator;

    [SWF(width=1500, height=800, frameRate=20, backgroundColor=0xE2E2E2)]
    public class Rummy extends Sprite{
        
        public var s1:Sprite;

        [Embed(source="../img/s2.png")]
        public var s2Bitmap: Class;
        public var s2:Sprite;
        public var timerCounter: int = 0;

        public var imageNamePrefix: Array.<String> = ["c", "d", "s", "h"];
        public var imageNames:Vector.<String>;
        public var points:Vector.<int> = new Vector.<int>;
        
        public var stack:Vector.<Sprite>;
        public var firstPlayerHand:Vector.<Sprite>;
        public var secondPlayerHand:Vector.<Sprite>;
        public var cardState:Vector.<uint>;
        public var bitmapDataList:Vector.<Bitmap>;

        public var bitmapData:BitmapData;

        public var spritesheet:BitmapData;

        public var animator:Animator;
        public var animationDuration = 1000;
        
        public var isFirstPlayerMove: Boolean = false;
        public var lastCardPoints:int;
        public var lastCardIndex: int;
        public var mainKind: int = 3;
        
        public var textLog:TextField = new TextField();

        public function Rummy(){
            //stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.LEFT;
            stage.quality = StageQuality.BEST;


            //background
            bitmapData = (new WelcomeScreen() as Bitmap).bitmapData;
            bitmapData = new BitmapData(1000, 600, false, 0x707070);
            addChild(new Bitmap(bitmapData));
            
            createTestCards();
            
            loadCardsToStack();
            moveToFirstPlayerHand();
            createNextMoveButton();
            //var myTween:Tween = new Tween(myObject, "x", Elastic.easeOut, 0, 300, 3, true);
            
        }

        private function loadStaticBitmaps():void{
                      
            
            bitmapDataList.push(new Bitmap((new Bitmaps1 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps2 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps3 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps4 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps5 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps6 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps7 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps8 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps9 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps10 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps11 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps12 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaps13 as Bitmap).bitmapData));
            
            bitmapDataList.push(new Bitmap((new Bitmaph1 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph2 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph3 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph4 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph5 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph6 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph7 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph8 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph9 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph10 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph11 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph12 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmaph13 as Bitmap).bitmapData));
            
            
            bitmapDataList.push(new Bitmap((new Bitmapc1 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc2 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc3 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc4 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc5 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc6 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc7 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc8 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc9 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc10 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc11 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc12 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapc13 as Bitmap).bitmapData));
            
            
            bitmapDataList.push(new Bitmap((new Bitmapd1 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd2 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd3 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd4 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd5 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd6 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd7 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd8 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd9 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd10 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd11 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd12 as Bitmap).bitmapData));
            bitmapDataList.push(new Bitmap((new Bitmapd13 as Bitmap).bitmapData));
            
            for(var i:int=0;i<bitmapDataList.length;i++){
                var s1:Sprite = new Sprite();
                s1.addChild(bitmapDataList[i]);
                s1.x = 10 + stack.length * 0;
                s1.y = 110 + stack.length * 1;
                s1.addEventListener(MouseEvent.MOUSE_DOWN, onClickHandler);
                addChild(s1);
                stack.push(s1);
                cardState.push(0);
            }
            stack[0].rotation = 90;
            stack[0].x = 300;
            stack[0].y = 200;
        }
        
        private var loader:Loader; // The bitmap loader
        private var moveInProgress:Boolean;
        
        private function createNextMoveButton():void{
            //next move button 
            var button:Sprite = new Sprite();
            button.addChild(new Bitmap(new BitmapData(150, 90, false, 0x9f9f00)));
            button.x = 1200;
            button.y = 300;
            var text:TextField = new TextField();
            text.text = "next move";
            button.addChild(text);
            addChild(button);
            button.addEventListener(MouseEvent.MOUSE_DOWN, handleNextMove);
            
        }
        
        
        private function loadCardsToStack():void{
            //card stack
            stack =             new Vector.<Sprite>;
            firstPlayerHand =   new Vector.<Sprite>;
            secondPlayerHand =  new Vector.<Sprite>;
            cardState =         new Vector.<uint>;
            bitmapDataList =        new Vector.<Bitmap>;
            //stack.push(s1, s2);
            imageNames = new Vector.<String>;
            for(var i:int = 1; i<14; i++){
                imageNames.push("../img/c"+ i + ".png");
            }
            for(var i:int = 1; i<14; i++){
                imageNames.push("../img/d"+ i + ".png");
            }
            for(var i:int = 1; i<14; i++){
                imageNames.push("../img/s"+ i + ".png");
            }
            for(var i:int = 1; i<14; i++){
                imageNames.push("../img/h"+ i + ".png");
            }
            imageNames.push("../img/cover.png");
            println("\n before loading images");
            
            for(var i:int = 1;i<5;i++){
                for(var j:int = 1;j<14;j++){
                    if(j==1) 
                        points.push(14 + i*100)
                    else 
                        points.push(j+i*100);
                }
            }
            //mainKind = getKind(0);
            
            loadStaticBitmaps();
            
            //bitmapLoader();
        }

        public function bitmapLoader( ):void {
            loader = new Loader( );
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,	loadCompleteListener);
            loader.load(new URLRequest(imageNames[stack.length]));
            //println("\n bitmap loader");
            //trace(imageNames[stack.length]);
            cardState.push(0);
        }
        
        // Triggered when the bitmap has been loaded and initialized
        private function loadCompleteListener (e:Event):void {
            println("\n img complete \n stack: " + stack.length);
            println("\n c: " + loader.content);
            var s3:Sprite = new Sprite();
            s3.addChild(loader.content);
            bitmapDataList.push(loader.content);
            s3.x = 10 + stack.length * 0;
            s3.y = 10 + stack.length * 2;
            addChild(s3);
            stack.push(s3);
            s3.addEventListener(MouseEvent.MOUSE_DOWN, onClickHandler);
            ///println("\n stack: " + stack.length);
            if(stack.length<imageNames.length){
                println("\n stack: " + stack.length);
                bitmapLoader();
            }else{
                removeChild(stack.pop());
                cardState.pop();
                moveToFirstPlayerHand();
            }
        }

        private function moveToFirstPlayerHand():void{
            trace("cardState: " + cardState);
            trace("points: " + points);
            for(var i:int = 1;i<7;i++){
                var sprite:Sprite = stack[52-i];
                cardState[52-i] = 1;
                //this is the way to hide cards
                //sprite.addChild(new Bitmap(bitmapDataList[52].bitmapData));
                firstPlayerHand.push(sprite);
                var animator:Animator = new Animator(sprite);
                animator.animateTo(100 + 150*i, -150, animationDuration + i*100);
                trace("stack size: " + stack.length + " 1: " + firstPlayerHand.length);
            }
            
            
            moveToSecondPlayerHand();
        }
        
        private function moveToSecondPlayerHand():void{
            trace("cardState: " + cardState);
            for(var i:int = 1;i<7;i++){
                var sprite:Sprite = stack[46-i];
                cardState[46-i] = 2;
                secondPlayerHand.push(sprite);
                //sprite.addChild(new Bitmap(bitmapDataList[52].bitmapData));
                var animator:Animator = new Animator(sprite);
                animator.animateTo(100 + 150*i, 400, animationDuration + i*100);
                trace("stack size: " + stack.length + " 1: " + secondPlayerHand.length);
            }
            trace("cardState: " + cardState);
            stage.addEventListener(Event.ENTER_FRAME, enterFrameListener);
        }
        
        private function moveToPlayer1Hand(sprite: Sprite, shift: int):void{
            new Animator(sprite).animateTo(100 + 150 * shift,  -150, animationDuration );
        }
        
        private function moveToPlayer2Hand(sprite: Sprite, shift: int):void{
            new Animator(sprite).animateTo(100 + 150 * shift, 400, animationDuration );
        }
        
        private function getKind(index:int):int{
            return (points[index] - (points[index]%100) ) /100;
        }
        
        private function getValue(index:int):int{
            return points[index]%100;
        }
        
        private function isAllowed(index: int):Boolean{
            //trace("table cards: " + countCardsOnTable());
            //trace("1pts vs 2pts: " + points[index] + " ~ " + points[lastCardIndex]);
            if ((isFirstPlayerMove && cardState[index] == 1) 
                || (!isFirstPlayerMove && cardState[index] == 2)){
                if(countCardsOnTable() % 2 == 1){
                    //trace("!!!need to check points!!!!!");
                    var point:int = points[index] % 100;
                    var kind :int = (points[index] - (points[index]%100) ) /100;
                    var lastPoint:int = points[lastCardIndex] % 100;
                    var lastKind :int = (points[lastCardIndex] - (points[lastCardIndex]%100) ) /100;
                    //trace("!!! " + point + ":" + kind +  " " + lastPoint + ":" + lastKind);
                    if((kind==lastKind)&&(point>lastPoint)){
                        return true;
                    }else if(kind==mainKind){    
                        return true;
                    }else {
                        trace("!!!kind is different!!!!!");
                        return false;
                    }
                }else{
                    return true;
                }
            }
            return false;
        }
        
        private function onClickHandler(e: MouseEvent):void{
            var cardIndex:int = stack.indexOf(e.currentTarget as Sprite);
            trace("click on  x: " + e.currentTarget.x + " y: " + e.currentTarget.y + " target : " + imageNames[cardIndex] + " : " + cardIndex);
            trace("pts: " + points[cardIndex]  + " lastCard pts: " + points[lastCardIndex]);
            if(isAllowed(cardIndex)){
                moveToCenter(e.currentTarget as Sprite, 20 * countCardsOnTable() + 200 * (Math.floor(countCardsOnTable()/2)));
                cardState[cardIndex] = 3;
                lastCardIndex = cardIndex;
                lastCardPoints = points[cardIndex];
                trace(isFirstPlayerMove + " :card state: " + cardState );
                trace("cards on table: " + countCardsOnTable());
                rearrangeCardsOnHands();
                isFirstPlayerMove = !isFirstPlayerMove;
            }
        }
        
        private function countCardsOnTable():uint {
            var counter:uint = 0;
            for(var i:int=0;i<cardState.length;i++){
                if(cardState[i]==3)
                    counter++;
            }
            return counter;
        }
        
        private function countCardsOnHand(player: uint):uint{
            var counter:uint = 0;
            for(var i:int=0;i<cardState.length;i++){
                if(cardState[i]==player)
                    counter++;
            }
            return counter;
        }
        
        private function moveToCenter(sprite: Sprite, shift: int):void{
            new Animator(sprite).animateTo(300 + shift, 150, animationDuration);
        }
        
        private function moveOut(sprite: Sprite, shift: int):void{
            new Animator(sprite).animateTo(1200, 10 + shift, animationDuration);
        }
        
        private function handleNextMove(e:MouseEvent):void{
            trace("handle next move:  " + isFirstPlayerMove);
            if(countCardsOnTable()%2==0){
                trace("clean up table");
                cleanUpTable();
            }else{
                trace("cards # " + countCardsOnTable());
                if(isFirstPlayerMove){
                    for(var i:int=0;i<cardState.length;i++){
                        if(cardState[i]==3){
                            cardState[i]=1;
                            moveToPlayer1Hand(stack[i], 6);
                        }
                    }
                }else{
                    for(var i:int=0;i<cardState.length;i++){
                        if(cardState[i]==3){
                            cardState[i]=2;
                            moveToPlayer2Hand(stack[i], 6);
                        }
                    }
                }
                //isFirstPlayerMove = !isFirstPlayerMove;
            }
            rearrangeCardsOnHands();
            
            //TODO: need to check stack.length 
            var p1cards:uint = countCardsOnHand(1);
            trace("p1cards:  " + p1cards);
            for(var i:int=p1cards;i<6;i++){
                var index:int = cardState.lastIndexOf(0);
                //trace("last 0 index: " + index);
                if(index!=-1){
                    cardState[index] = 1;
                    moveToPlayer1Hand(stack[index], i+1);
                }
            }
            var p2cards:uint = countCardsOnHand(2);
            trace("p2cards: "  + p2cards);
            for(var i:int=p2cards;i<6;i++){
                var index:int = cardState.lastIndexOf(0);
                //trace("last 0 index: " + index);
                if(index!=-1){
                    cardState[index] = 2;
                    moveToPlayer2Hand(stack[index], i+1);
                }
            }
            isFirstPlayerMove = !isFirstPlayerMove;
            
        }
        
        private function cleanUpTable():void{
            for(var i:int=0;i<cardState.length;i++){
                if(cardState[i]==3){
                    cardState[i]=4;
                    moveOut(stack[i], 0);
                }
            }
        }
        
        // Handles Event.ENTER_FRAME events. 
        private function enterFrameListener (e:Event):void {
            //trace("onEnterFrame: " + timerCounter++ + " : " + getTimer());
            //for(var i:int=0;i<cardState.length;i++){
                //check something
            //}
        }
        
        private function rearrangeCardsOnHands():void{
            var tableCardsCounter = 0;
            var player1CardsCounter = 0;
            var player2CardsCounter = 0;
            for(var i:int=cardState.length-1;i>=0;i--){
                if(cardState[i]==3){
                    tableCardsCounter++;
                    //trace("card " + i + " on table");
                    //moveOut(stack[i]);
                }
                if(cardState[i]==1){
                    player1CardsCounter++;
                    //trace("1: " + i);
                    moveToPlayer1Hand(stack[i], player1CardsCounter);
                    //trace("card: " + i + " z-index: " +  getChildIndex(stack[i]));
                    //setChildIndex(stack[i], player1CardsCounter);
                }
                if(cardState[i]==2){
                    player2CardsCounter++;
                    //trace("2: " + i);
                    moveToPlayer2Hand(stack[i], player2CardsCounter);
                }
                
            }
        }
        
        //OLD CODE
        //Will be removed later
        private function mouseDownListener (e:MouseEvent):void {
            var mousePt:Point = globalToLocal(new Point(e.stageX, e.stageY));
            animator.animateTo(mousePt.x, mousePt.y, 500);
        }
        
        private function moveToCenter2(e:MouseEvent):void{
            trace(e.currentTarget + " move to center");
            var mousePt:Point = globalToLocal(new Point(e.stageX, e.stageY));
            var animator2:Animator = new Animator(s2);
            animator2.animateTo(500, 250, 500);
        }
        
        private function generalMoveToCenter(e:MouseEvent):void{
            trace("generalMoveToCenter1: x:" + (e.currentTarget as Sprite).x);
            var mousePt:Point = globalToLocal(new Point(e.stageX, e.stageY));
            var animator2:Animator = new Animator(e.currentTarget as Sprite);
            animator2.animateTo(700, 150, 500);
            trace("generalMoveToCenter2: x:" + (e.currentTarget as Sprite).x);
        }
        
        private function createTestCards():void{
            //first card 
            s1 = new Sprite();
            //s1.addChild(new Bitmap((new s1Bitmap as Bitmap).bitmapData));
            s1.addChild(new Bitmap(new BitmapData(150, 90, false, 0x7f7f00)));
            s1.x = 800;
            s1.y = 400;
            var text:TextField = new TextField();
            text.text = "old code";
            s1.addChild(text);
            //addChild(s1);
            s1.addEventListener(MouseEvent.MOUSE_DOWN, generalMoveToCenter);
            
            //animator = new Animator(s1);
            
            //second card 
            s2 = new Sprite();
            //s1.addChild(new Bitmap((new s1Bitmap as Bitmap).bitmapData));
            s2.addChild(new Bitmap(new BitmapData(50, 90, false, 0x808080)));
            s2.x = 50;
            s2.y = 150;
            var text2:TextField = new TextField();
            text2.text = "s2";
            s2.addChild(text2);
            addChild(s2);
            s2.addEventListener(MouseEvent.MOUSE_DOWN, moveToCenter2);
            trace("start loading images");
            
            textLog.text = "initial log";
            textLog.x = 800;
            textLog.y = 800;
            addChild(textLog);
            
        }
        
        private function println(s: String):void{
            textLog.text = textLog.text + s;
        }
        
        //background image
        [Embed(source="../img/welcomeScreen.png")]
        public var WelcomeScreen:Class;
        
        //spades
        [Embed(source="../img/s1.png")]
        public var Bitmaps1: Class;
        [Embed(source="../img/s2.png")]
        public var Bitmaps2: Class;
        [Embed(source="../img/s3.png")]
        public var Bitmaps3: Class;
        [Embed(source="../img/s4.png")]
        public var Bitmaps4: Class;
        [Embed(source="../img/s5.png")]
        public var Bitmaps5: Class;
        [Embed(source="../img/s6.png")]
        public var Bitmaps6: Class;
        [Embed(source="../img/s7.png")]
        public var Bitmaps7: Class;
        [Embed(source="../img/s8.png")]
        public var Bitmaps8: Class;
        [Embed(source="../img/s9.png")]
        public var Bitmaps9: Class;
        [Embed(source="../img/s10.png")]
        public var Bitmaps10: Class;
        [Embed(source="../img/s11.png")]
        public var Bitmaps11: Class;
        [Embed(source="../img/s12.png")]
        public var Bitmaps12: Class;
        [Embed(source="../img/s13.png")]
        public var Bitmaps13: Class;
        
        //hearts
        [Embed(source="../img/h1.png")]
        public var Bitmaph1: Class;
        [Embed(source="../img/h2.png")]
        public var Bitmaph2: Class;
        [Embed(source="../img/h3.png")]
        public var Bitmaph3: Class;
        [Embed(source="../img/h4.png")]
        public var Bitmaph4: Class;
        [Embed(source="../img/h5.png")]
        public var Bitmaph5: Class;
        [Embed(source="../img/h6.png")]
        public var Bitmaph6: Class;
        [Embed(source="../img/h7.png")]
        public var Bitmaph7: Class;
        [Embed(source="../img/h8.png")]
        public var Bitmaph8: Class;
        [Embed(source="../img/h9.png")]
        public var Bitmaph9: Class;
        [Embed(source="../img/h10.png")]
        public var Bitmaph10: Class;
        [Embed(source="../img/h11.png")]
        public var Bitmaph11: Class;
        [Embed(source="../img/h12.png")]
        public var Bitmaph12: Class;
        [Embed(source="../img/h13.png")]
        public var Bitmaph13: Class;
        
        //clubs
        [Embed(source="../img/c1.png")]
        public var Bitmapc1: Class;
        [Embed(source="../img/c2.png")]
        public var Bitmapc2: Class;
        [Embed(source="../img/c3.png")]
        public var Bitmapc3: Class;
        [Embed(source="../img/c4.png")]
        public var Bitmapc4: Class;
        [Embed(source="../img/c5.png")]
        public var Bitmapc5: Class;
        [Embed(source="../img/c6.png")]
        public var Bitmapc6: Class;
        [Embed(source="../img/c7.png")]
        public var Bitmapc7: Class;
        [Embed(source="../img/c8.png")]
        public var Bitmapc8: Class;
        [Embed(source="../img/c9.png")]
        public var Bitmapc9: Class;
        [Embed(source="../img/c10.png")]
        public var Bitmapc10: Class;
        [Embed(source="../img/c11.png")]
        public var Bitmapc11: Class;
        [Embed(source="../img/c12.png")]
        public var Bitmapc12: Class;
        [Embed(source="../img/c13.png")]
        public var Bitmapc13: Class;
        
        //diamonds
        [Embed(source="../img/d1.png")]
        public var Bitmapd1: Class;
        [Embed(source="../img/d2.png")]
        public var Bitmapd2: Class;
        [Embed(source="../img/d3.png")]
        public var Bitmapd3: Class;
        [Embed(source="../img/d4.png")]
        public var Bitmapd4: Class;
        [Embed(source="../img/d5.png")]
        public var Bitmapd5: Class;
        [Embed(source="../img/d6.png")]
        public var Bitmapd6: Class;
        [Embed(source="../img/d7.png")]
        public var Bitmapd7: Class;
        [Embed(source="../img/d8.png")]
        public var Bitmapd8: Class;
        [Embed(source="../img/d9.png")]
        public var Bitmapd9: Class;
        [Embed(source="../img/d10.png")]
        public var Bitmapd10: Class;
        [Embed(source="../img/d11.png")]
        public var Bitmapd11: Class;
        [Embed(source="../img/d12.png")]
        public var Bitmapd12: Class;
        [Embed(source="../img/d13.png")]
        public var Bitmapd13: Class;
        
        //card images
        [Embed(source="../img/s1.png")]
        public var s1Bitmap: Class;
    }
}