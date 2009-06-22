Shoes.app do
  stack do
    fill burlywood 
    image :width => 80, :height => 80 do
      oval :radius => 40
      click { alert 'i was clicked' }
    end
    para 'end'
  end
end
