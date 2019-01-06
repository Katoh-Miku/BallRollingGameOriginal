//
// ボール転がし
//

/*
  (操作方法)
 〇マウス操作
 〇クリックしている間、マウスカーソルを追尾するように移動します。
 〇黄色のアイテムを集める。
 〇ただし、アイテムの個数、位置はランダムです。
 
 */

// ボール転がし本体
BallRolling ballrolling;

//変数の定義
int mouseClickCount = 0;
int quiteNumber = 0;

// セットアップ
void setup() {
  size(600, 600);
  background(0);
  noStroke();
  ballrolling = new BallRolling();
}

// 1フレームごとの描写処理
void draw() {
  background(0);
  if (mouseClickCount == 0) startWindow();
  else ballrolling.draw();
}

/*
 * ボール転がし
 */
class BallRolling {
  final int itemNum = int(random(2, 7));
  final int itemD = 20;                 // アイテムの直径
  final int empty = 25;                 // アイテムが生成されない大きさ
  int itemX;                            // アイテムのX座標
  int itemY;                            // アイテムのY座標

  // 各オブジェクトの定義
  Ball ball;
  Item[][] item;
  // コンストラクタ
  BallRolling() {
    // ボールの生成
    ball = new Ball(width / 2, height / 2, 1.2, 1.2, itemD * 2);
    // アイテムの生成
    item = new Item[itemNum][2];
    for (int i = 0; i < item.length; i++) {
      for (int j = 0; j < item[i].length; j++) {
        itemX = int(random(empty, width - empty)); 
        itemY = int(random(empty, height - empty));
        item[i][j] = new Item(itemX, itemY, itemD);
      }
    }
  }

  /** 1フレームごとの描写処理 */
  void draw() {
    int getterItemNum = 0;          // 獲得したアイテムの個数

    for (int i = 0; i < item.length; i++) {
      for (int j = 0; j < item[i].length; j++) {
        if (!item[i][j].isCollect()) {
          item[i][j].collision(ball);
          item[i][j].show();
        } else {
          getterItemNum++;
        }
      }
    }

    if (getterItemNum < itemNum * 2) {
      ball.show();
    } else {
      afterWindow();                  // アイテムをすべて集めたのなら、クリア画面を表示
    }

    // 残りのアイテムの個数を表示
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Item : " + (itemNum * 2 - getterItemNum), width - 50, height - 25);
  }
}

/*
 * ボール
 */
class Ball {
  float x;                        // ボールのX座標
  float y;                        // ボールのY座標
  float vx;                       // ボールのX軸速度
  float vy;                       // ボールのY軸速度
  int d;                          // ボールの直径
  float targetX;                  // マウスのX座標
  float targetY;                  // マウスのY座標
  float easing = 0.025;           // マウスに近づく速さ

  // コンストラクタ
  Ball(int x, int y, float vx, float vy, int d) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.d = d;
    this.targetX = mouseX;
    this.targetY = mouseY;
  }

  // ボールの描写
  void show() {
    if (mousePressed) {
      float targetX = mouseX;
      float targetY = mouseY;
      x += vx;
      y += vy;
      x = x + (targetX - x) * easing;
      y = y + (targetY - y) * easing;
    }
    fill(250, 130, 166);                // ボールの色はピンク
    ellipse(x, y, d, d);
  }

  float getX() {
    return  + x;
  }
  float getY() {
    return  + y;
  }
  float getRadius() {
    return d / 2;
  }
}

/*
 * アイテム (衝突判定含む)
 */
class Item {
  int x;                          // アイテムのX座標
  int y;                          // アイテムのY座標 
  int d;                          // アイテムの直径
  float dx;                       // 水平方向の距離
  float dy;                       // 垂直方向の距離
  float dr;                       // 半径の和
  boolean collect;                // アイテムを獲得したか否か

  // コンストラクタ
  Item(int x, int y, int d) {
    this.x = x;
    this.y = y;
    this.d = d;
    collect = false;
  }

  // アイテムの描写
  void show() {
    fill(255, 250, 100);          // アイテムの色は黄色
    ellipse(x, y, d, d);
  }

  // 衝突判定
  void collision(Ball ball) {
    dx = abs(ball.getX() - x);
    dy = abs(ball.getY() - y);
    dr = ball.getRadius() + d;
    if ( (sqrt( sq(dx) + sq(dy) ) < dr) && mousePressed) {
      collect = true;
    }
  }

  boolean isCollect() {
    return collect;
  }
}

/*-------スタート画面-------*/
void startWindow() {
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Ball Rolling.", width / 2, height / 3);
  textSize(25);
  textAlign(CENTER, CENTER);
  text("- Click to start -", width / 2, height / 2);
}

/*-------星の描画-------*/
void drawStar(float px, float py) {
  noStroke();
  smooth();
  fill(255, 255, 0);
  beginShape();
    vertex(px      , py - 20);
    vertex(px - 12 , py + 15);
    vertex(px + 18 , py -  8);
    vertex(px - 18 , py -  8);
    vertex(px + 12 , py + 15);
  endShape(CLOSE);
}

/*-------GAME終了後の画面-------*/
void afterWindow() {
  drawStar(width / 2, height / 2);
  fill(255);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("GAME CLEAR!", width / 2, height / 3);
  textSize(25);
  textAlign(CENTER, CENTER);
  text("- Click to end-", width / 2, height / 1.7);
  quiteNumber = 1;
}

/*-------星の描画-------*/
void drawStar(int px,int py) {
  noStroke();
  smooth();
  fill(255, 255, 0);
  beginShape();
    vertex(px      , py - 20);
    vertex(px - 12 , py + 15);
    vertex(px + 18 , py -  8);
    vertex(px - 18 , py -  8);
    vertex(px + 12 , py + 15);
  endShape(CLOSE);
}

/*-------GAME終了後の終了のメソッド------*/
void mouseClicked() {
  mouseClickCount++;
  println(mouseClickCount);
  if (quiteNumber==1) {
    exit();
  }
}
