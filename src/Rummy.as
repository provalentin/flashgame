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

import fl.transitions.Tween;
	
    [SWF(width=1500, height=800, frameRate=10, backgroundColor=0xE2E2E2)]
    public class Rummy extends Sprite{
        //background image
        [Embed(source="../img/welcomeScreen.png")]
        public var WelcomeScreen:Class;

        //card images
        [Embed(source="../img/s1.png")]
        public var s1Bitmap: Class;
        public var s1:Sprite;

        [Embed(source="../img/s2.png")]
        public var s2Bitmap: Class;
        public var s2:Sprite;
        public var timerCounter: int = 0;

        public var imageNamePrefix: Array.<String> = ["c", "d", "s", "h"];
        public var imageNames:Vector.<String>;
        
        public var stack:Vector.<Sprite>;
        public var firstPlayerHand:Vector.<Sprite>;
        public var secondPlayerHand:Vector.<Sprite>;
        public var cardState:Vector.<uint>;
        public var bitmapDataList:Vector.<Bitmap>;

        public var bitmapData:BitmapData;

        public var spritesheet:BitmapData;

        public var animator:Animator;
        public var animationDuration = 2000;
        
        public var isFirstPlayerMove: Boolean = false;

        public function Rummy(){
            //stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.LEFT;
            stage.quality = StageQuality.BEST;


            //background
            bitmapData = (new WelcomeScreen() as Bitmap).bitmapData;
            bitmapData = new BitmapData(1000, 600, false, 0x707070);
            addChild(new Bitmap(bitmapData));
            
            //createTestCards();
            
            loadCardsToStack();
            createNextMoveButton();
            //var myTween:Tween = new Tween(myObject, "x", Elastic.easeOut, 0, 300, 3, true);
            
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
            
            bitmapLoader();
        }

        public function bitmapLoader( ):void {
            loader = new Loader( );
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,	loadCompleteListener);
            loader.load(new URLRequest(imageNames[stack.length]));
            trace(imageNames[stack.length]);
            cardState.push(0);
        }
        
        // Triggered when the bitmap has been loaded and initialized
        private function loadCompleteListener (e:Event):void {
            var s3:Sprite = new Sprite();
            s3.addChild(loader.content);
            bitmapDataList.push(loader.content);
            s3.x = 10 + stack.length * 0;
            s3.y = 10 + stack.length * 2;
            addChild(s3);
            stack.push(s3);
            s3.addEventListener(MouseEvent.MOUSE_DOWN, onClickHandler);
            if(stack.length<imageNames.length){
                bitmapLoader();
            }else{
                removeChild(stack.pop());
                cardState.pop();
                moveToFirstPlayerHand();
            }
        }

        private function moveToFirstPlayerHand():void{
            trace("cardState: " + cardState);
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
        
        private function onClickHandler(e: MouseEvent):void{
            var cardIndex:int = stack.indexOf(e.currentTarget as Sprite);
            trace("click on  x: " + e.currentTarget.x + " y: " + e.currentTarget.y + " target : " + imageNames[cardIndex] + " : " + cardIndex);
            if((isFirstPlayerMove && cardState[cardIndex] == 1) 
                || (!isFirstPlayerMove && cardState[cardIndex] == 2)){
                moveToCenter(e.currentTarget as Sprite, 20 * countCardsOnTable() + 200 * (Math.floor(countCardsOnTable()/2)));
                cardState[cardIndex] = 3;
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
            trace("handle next move: clean up table");
            cleanUpTable();
            rearrangeCardsOnHands();
            
            //TODO: need to check stack.length 
            var p1cards:uint = countCardsOnHand(1);
            trace("p1cards: " + p1cards);
            for(var i:int=p1cards;i<6;i++){
                var index:int = cardState.lastIndexOf(0);
                trace("last 0 index: " + index);
                if(index!=-1){
                    cardState[index] = 1;
                    moveToPlayer1Hand(stack[index], i+1);
                }
            }
            var p2cards:uint = countCardsOnHand(2);
            trace("p2cards: "  + p2cards);
            for(var i:int=p2cards;i<6;i++){
                var index:int = cardState.lastIndexOf(0);
                trace("last 0 index: " + index);
                if(index!=-1){
                    cardState[index] = 2;
                    moveToPlayer2Hand(stack[index], i+1);
                }
            }
            
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
                    trace("card " + i + " on table");
                    //moveOut(stack[i]);
                }
                if(cardState[i]==1){
                    player1CardsCounter++;
                    //trace("1: " + i);
                    moveToPlayer1Hand(stack[i], player1CardsCounter);
                    trace("card: " + i + " z-index: " +  getChildIndex(stack[i]));
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
            addChild(s1);
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
        }
    }
}