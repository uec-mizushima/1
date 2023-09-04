Pixel = Struct.new(:r, :g, :b)
$img = Array.new(900) do
  Array.new(900) do Pixel.new(255,255,255) end
end
def pset(x, y, r, g, b)
  if 0 <= x && x < 900 && 0 <= y && y < 900
    $img[y][x].r = r; $img[y][x].g = g; $img[y][x].b = b
  end
end

def fillcircle(x0, y0, rad, r, g, b)
  900.times do |y|
    900.times do |x|
      if (x-x0)**2 + (y-y0)**2 <= rad**2
        pset(x, y, r, g, b)
      end
    end
  end
  writeimage('t.ppm')
end

def fillcircle3(x0, y0, rad, r, g, b, x1, x2, y1, y2)
  900.times do |y|
    900.times do |x|
      if (x-x0)**2 + (y-y0)**2 <= rad**2
        if x > x1 && x < x2 && y > y1 && y < y2
          pset(x, y, r, g, b)
        end
      end
    end
  end
  writeimage('t.ppm')
end
def filk(x0, y0, rad, r, g, b, k, l)
  fillcircle2(x0, y0, rad, r, g, b) do |x, y|
    theta = Math.atan2(y-y0, x-x0) * 180 / Math::PI
    if theta>k || theta<l then pset(x,y,r, g, b) end
  end
  writeimage('t.ppm')
end

def filk2(x0, y0, rad, r, g, b, k, l)
  filk(x0, y0, rad, r, g, b, k, l)
  writeimage('t.ppm')
end

def kamon
  fillcircle(450, 450, 446, 0, 0, 0)
  fillcircle(383,338,325,255,255,255)
  filk2(383,338,325,0,0,0,85,-110)
  filk2(517,562,325,255,255,255,70,-100)
  fillcircle(450,650,196,0,0,0)
  fillcircle(450,250,196,0,0,0)
  fillcircle3(531,563,310,0,0,0,259,650,732,890)
  fillcircle3(364,330,310,0,0,0,250,641,10,168)
  writeimage('t.ppm')
end

def kamon1
  fillcircle3(531,563,310,0,0,0,259,650,732,890)
  fillcircle3(364,330,310,0,0,0,250,641,10,168)
  writeimage('t8.ppm')
end
  

def fillcircle2(x0, y0, rad, r, g, b)
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

def writeimage(name)
  open(name, "wb") do |f|
    f.puts("P6\n900 900\n255")
    $img.each do |a|
      a.each do |p| f.write(p.to_a.pack("ccc")) end
    end
  end
end
