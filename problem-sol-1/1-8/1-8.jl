function inttosideconverter(b)
    return HorizonSide(abs(b%4))
end
function reverse(side)
    return HorizonSide((Int(side)+2)%4)
end
function move_for_steps!(r::Robot, steps, side)
    for i in 1:steps
        move!(r, side)
    end
end
function find_the_hole!(r)
    n=1
    side=Ost
    while isborder(r, Nord)
        move_for_steps!(r, n, side)
        n+=1
        side=reverse(side)
    end
end