#「基礎プログラミングおよび演習」資料より一部引用

Pixel = Struct.new(:r, :g, :b)
$img = Array.new(900) do
  Array.new(900) do Pixel.new(255,255,255) end
end

#指定した座標に色を設定
def pset(x, y, r, g, b)
  if 0 <= x && x < 900 && 0 <= y && y < 900
    $img[y][x].r = r; $img[y][x].g = g; $img[y][x].b = b
  end
end

#円を描画
def fillcircle(x0, y0, rad, r, g, b)
  900.times do |y|
    900.times do |x|
      if (x-x0)**2 + (y-y0)**2 <= rad**2
        if block_given? then yield x, y
        else pset(x, y, r, g, b)
        end
      end
    end
  end
end

#画像をファイルに保存
def writeimage(name)
  open(name, "wb") do |f|
    f.puts("P6\n900 900\n255")
    $img.each do |a|
      a.each do |p| f.write(p.to_a.pack("ccc")) end
    end
  end
end

#円弧を描画する関数（改良前）
def mypicture3(x0, y0, rad, r, g, b, start_deg, end_deg)
  fillcircle(x0, y0, rad, r, g, b) do |x, y|
    #中心(x0,y0)から点(x,y)に引いた線分が水平に対してなす角度を求める
    theta = Math.atan2(y-y0, x-x0) * 180 / Math::PI
    #角度が指定した範囲外の時のみ塗る
    if theta>start_deg || theta<end_deg then pset(x, y, r, g, b) end#Math.atan2の返される値の範囲は -180から180のため、それを超える範囲は切り取ることができない
  end
end

#円弧を描画する関数（改良後）
def fill_arc(x0, y0, rad, r, g, b, start_deg, end_deg)
  #角度パラメータが-180未満または180を超える場合、左右反転するよう値を調整し、もう一回左右を反転させる
  if start_deg > 180 || start_deg < -180
    dir = -1#左右反転あり
    start_deg_norm = 180 - end_deg
    end_deg_norm = 180 - start_deg
  elsif end_deg > 180 || end_deg < -180
    dir = -1#左右反転あり
    start_deg_norm = -180 - end_deg
    end_deg_norm = -180 - start_deg
  else
    dir = 1#左右反転なし
    start_deg_norm = start_deg
    end_deg_norm = end_deg
  end
  fillcircle(x0, y0, rad, r, g, b) do |x, y|
    theta = Math.atan2(y-y0, dir * (x-x0)) * 180 / Math::PI#dirが-1のとき左右が反対になる
    if theta > start_deg_norm || theta < end_deg_norm then pset(x, y, r, g, b) end
  end
end

def main
  #改良前の関数
  mypicture3(225, 225, 200, 255, 0, 0, 20, -40)
  mypicture3(675, 225, 200, 0, 255, 0, -140, -200)#-180を超える角度は切り取ることができない

  #改良後の関数
  fill_arc(225, 675, 225, 0, 0, 255, 20, -40)
  fill_arc(675, 675, 225, 0, 255, 255, -140, -200)#角度パラメータをそれぞれ20と-40に調整し、左右反転させることで正しく描画できる
  writeimage('t.ppm')
end
