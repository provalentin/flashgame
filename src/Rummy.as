package{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import Animator;

    [SWF(width=2200, height=800, frameRate=30, backgroundColor=0xE2E2E2)]
    public class Rummy extends Sprite{
        
        public var s1:Sprite;

        [Embed(source="../img/s2.png")]
        public var s2Bitmap: Class;
        public var s2:Sprite;
        public var timerCounter: int = 0;

        public var imageNamePrefix: Array.<String> = ["c", "d", "s", "h"];
        public var imageNames:Vector.<String>;
        public var points:Vector.<int> = new Vector.<int>;
        
        public var stack:Vector.<Sprite> = new Vector.<Sprite>;
        public var firstPlayerHand:Vector.<int> = new Vector.<int>;
        public var secondPlayerHand:Vector.<int> = new Vector.<int>;
        public var cardState:Vector.<uint> = new Vector.<uint>;
        public var bitmapDataList:Vector.<Bitmap> = new Vector.<Bitmap>;
		
		public var winnerText:TextField = new TextField();

        public var bitmapData:BitmapData;
		public var bitmapCover:Bitmap;

        public var spritesheet:BitmapData;

        public var animator:Animator;
        public var animationDuration:int = 500;
        
        public var isFirstPlayerMove: Boolean = false;
        public var lastCardPoints:int;
        public var lastCardIndex: int;
        public var mainKind: int = 1;
		public var mainKindIndex:int = 0;
        
        public var textLog:TextField = new TextField();
		private var moveInProgress:Boolean;

        public function Rummy(){
            stage.align = StageAlign.LEFT;
            stage.quality = StageQuality.BEST;
			bitmapCover = new Bitmap((new coverBitmap as Bitmap).bitmapData);
			createWinnerLabel();
            loadCardsToStack();
			loadBitmapDataList();
			initStack(); 
			refillHand(1);
			refillHand(2);
            createNextMoveButton();
        }
        
		private function initStack():void{
			for(var i:int=0;i<bitmapDataList.length;i++){
				var s1:Sprite = new Sprite();
				s1.addChild(bitmapDataList[i]);
				s1.x = 10 + stack.length * 0;
				s1.y = 110 + stack.length * 1;
				s1.addEventListener(MouseEvent.MOUSE_DOWN, onClickHandler);
				addChild(s1);
				stack.push(s1);
				s1.addChild(new Bitmap((new coverBitmap as Bitmap).bitmapData));
				cardState.push(0);
			}
			mainKindIndex = Math.floor(Math.random() * 36);
			mainKind = getKind(mainKindIndex);
			showCard(mainKindIndex);
			stack[mainKindIndex].x = 100;
			stack[mainKindIndex].y = 150;
		}
        
        private function createNextMoveButton():void{
            var button:Sprite = new Sprite();
            button.addChild(new Bitmap(new BitmapData(150, 90, false, 0xFFFFFF)));
            button.x = 1200;
            button.y = 300;
            var text:TextField = new TextField();
            text.text = "next move ";
			text.width = 200;
			text.setTextFormat(new TextFormat("Verdana",35, 0x000000));
            button.addChild(text);
            addChild(button);
            button.addEventListener(MouseEvent.MOUSE_DOWN, handleNextMove);
        }
		
		private function createWinnerLabel():void{
			var button2:Sprite = new Sprite();
			button2.addChild(new Bitmap(new BitmapData(350, 90, false, 0xFFFFFF)));
			button2.x = 1200;
			button2.y = 250;
			winnerText.text = "  ";
			winnerText.width = 300;
			winnerText.setTextFormat(new TextFormat("Verdana", 35, 0xFF0000));
			button2.addChild(winnerText);
			addChild(button2);
		}
        
        private function loadCardsToStack():void{
            for(var i:int = 1;i<5;i++){
                for(var j:int = 6;j<=14;j++){
                    points.push(j+i*100);
                }
            }
        }
		
		private function isEndGame():int{
			var p0:int = countCardsOnHand(0);
			var p1:int = countCardsOnHand(1);
			var p2:int = countCardsOnHand(2);
			if(p0==0) {
				if((p1==0)&&(p2==0)) return 0;
				if(p1==0) return 1;
				if(p2==0) return 2;
			}
			return -1;
		}

		private function getNextRandom():int {
			var value:int = -1;
			for(var i:int=0;i<100;i++){
				value = Math.floor(Math.random() * 36);
				if(mainKindIndex==value){
					if(countCardsOnHand(0)==1) break;
				}else{	
					if(cardState[value] == 0) break;
				}
			}
			return value;
		}

		private function moveToPlayerHand(sprite: Sprite, shift: int, hand: int):void{
			new Animator(sprite).animateTo(50 + 180 * shift,  hand==1?-150:400, animationDuration );
		}
		
        private function moveToPlayer1Hand(sprite: Sprite, shift: int):void{
            new Animator(sprite).animateTo(50 + 180 * shift,  -150, animationDuration );
        }
        
        private function moveToPlayer2Hand(sprite: Sprite, shift: int):void{
            new Animator(sprite).animateTo(50 + 180 * shift, 400, animationDuration );
        }
        
		private function moveToCenter(sprite: Sprite, shift: int):void{
			new Animator(sprite).animateTo(300 + shift, 150, animationDuration);
		}
		
		private function moveOut(sprite: Sprite, shift: int):void{
			new Animator(sprite).animateTo(1700, 10 + shift, animationDuration);
		}
		
        private function getKind(index:int):int{
            return (points[index] - (points[index]%100) ) /100;
        }
        
        private function getValue(index:int):int{
            return points[index]%100;
        }
        
        private function isAllowed(index: int):Boolean{
            if ((isFirstPlayerMove && cardState[index] == 1) 
                || (!isFirstPlayerMove && cardState[index] == 2)){
				if(countCardsOnTable()==0) return true;
                if(countCardsOnTable() % 2 == 1){
                    if((getKind(index)==getKind(lastCardIndex))){
						return (getValue(index)>getValue(lastCardIndex))
                    }
					return (getKind(index)==mainKind)  
                }else{
	                for(var i:int =0;i<cardState.length;i++){
	                    if(cardState[i]==3){
	                        if(getValue(index)==getValue(i)){
	                            return true;
	                        }
	                    }
	                }
	                return false;
                }
            }
            return false;
        }
        
        private function onClickHandler(e: MouseEvent):void{
			var cardIndex:int = stack.indexOf(e.currentTarget as Sprite);
            if(isAllowed(cardIndex)){
               moveCard(cardIndex); 
            }
			if(isFirstPlayerMove) {
				var cardIndex:int = computerMove();
				if(isAllowed(cardIndex) ) {
					moveCard(cardIndex);
					showCard(cardIndex);
				}
			}
        }
		
		private function moveCard(cardIndex: int):void{
			moveToCenter(stack[cardIndex], 20 * countCardsOnTable() + 200 * (Math.floor(countCardsOnTable()/2)));
			cardState[cardIndex] = 3;
			lastCardIndex = cardIndex;
			lastCardPoints = points[cardIndex];
			rearrangeCardsOnHands();
			isFirstPlayerMove = !isFirstPlayerMove;
		}
        
        private function countCardsOnTable():uint {
            return countCardsOnHand(3);
        }
        
        private function countCardsOnHand(player: uint):uint{
            var counter:uint = 0;
            for(var i:int=0;i<cardState.length;i++){
                if(cardState[i]==player) counter++;
            }
            return counter;
        }
        
        private function handleNextMove(e:MouseEvent):void{
            if(isEndGame()>=0) {
				winnerText.appendText("Winner is " + isEndGame());
			}else{
				cleanUpTable();
	            rearrangeCardsOnHands();
	            refillHand(1);
				refillHand(2);
	            isFirstPlayerMove = !isFirstPlayerMove;
				if(isFirstPlayerMove) {
					var cardIndex:int = computerMove();
					if(isAllowed(cardIndex) ) {
						moveCard(cardIndex);
						showCard(cardIndex);
					}
				}
			}
        }
		
		private function computerMove():int {
			var value:uint;
			for(var i:int=0;i<100;i++){
				value = Math.floor(Math.random() * 36);
				if(cardState[value]==1){
					if(isAllowed(value)) break;
				}
			}
			return value;
		}
		
		private function refillHand(hand: int):void{
			var cards:uint = countCardsOnHand(hand);
			for(var i:int=cards;i<6;i++){
				var index:int = getNextRandom();
				if(countCardsOnHand(0)>0){
					cardState[index] = hand; 
					moveToPlayerHand(stack[index], i+1, hand);
					if(hand==2)
					showCard(index);
				}
			}
			rearrangeCardsOnHands();
		}
		
        private function cleanUpTable():void{
			if(countCardsOnTable()%2==0){
				for(var i:int=0;i<cardState.length;i++){
					if(cardState[i]==3){
						cardState[i]=4;
						moveOut(stack[i], 0);
						hideCard(i);
					}
				}
			}else{
				for(var i:int=0;i<cardState.length;i++){
					if(cardState[i]==3){
						cardState[i]=isFirstPlayerMove?1:2;
						moveToPlayer1Hand(stack[i], 6);
							if(isFirstPlayerMove) 
								hideCard(i);
					}
				}
			}
        }
        
        private function rearrangeCardsOnHands():void{
            var tableCardsCounter:int = 0;
            var player1CardsCounter:int = 0;
            var player2CardsCounter:int = 0;
            for(var i:int=cardState.length-1;i>=0;i--){
                if(cardState[i]==3){
                    tableCardsCounter++;
                }
                if(cardState[i]==1){
                    player1CardsCounter++;
                    moveToPlayer1Hand(stack[i], player1CardsCounter);
                }
                if(cardState[i]==2){
                    player2CardsCounter++;
                    moveToPlayer2Hand(stack[i], player2CardsCounter);
                }
                
            }
        }
		
		private function hideCard(cardIndex:int):void{
			stack[cardIndex].addChild(new Bitmap((new coverBitmap as Bitmap).bitmapData));
		}
		
		private function showCard(cardIndex:int):void{
			stack[cardIndex].addChild(bitmapDataList[cardIndex]);
		}
        
		private function loadBitmapDataList():void{
			
			
			
			//            bitmapDataList.push(new Bitmap((new Bitmaps2 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmaps3 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmaps4 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmaps5 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps6 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps7 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps8 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps9 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps10 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps11 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps12 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps13 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaps1 as Bitmap).bitmapData));
			
			
			//            bitmapDataList.push(new Bitmap((new Bitmaph2 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmaph3 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmaph4 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmaph5 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph6 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph7 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph8 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph9 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph10 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph11 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph12 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph13 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmaph1 as Bitmap).bitmapData));
			
			
			
			//            bitmapDataList.push(new Bitmap((new Bitmapc2 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmapc3 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmapc4 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmapc5 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc6 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc7 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc8 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc9 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc10 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc11 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc12 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc13 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapc1 as Bitmap).bitmapData));
			
			
			
			//            bitmapDataList.push(new Bitmap((new Bitmapd2 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmapd3 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmapd4 as Bitmap).bitmapData));
			//            bitmapDataList.push(new Bitmap((new Bitmapd5 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd6 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd7 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd8 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd9 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd10 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd11 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd12 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd13 as Bitmap).bitmapData));
			bitmapDataList.push(new Bitmap((new Bitmapd1 as Bitmap).bitmapData));
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
		
		[Embed(source="../img/cover.png")]
		public var coverBitmap: Class;
    }
}