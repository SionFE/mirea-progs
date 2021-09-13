function reverse(side)
    return HorizonSide((Int(side)+2)%4)
end
function cross(r)
    for i in (HorizonSide(s) for s in 0:3)
        while isborder(r,i)==false
            move!(r,i)
            putmarker!(r)
        end
        while ismarker(r)==true
            move!(r,reverse(i))
        end
    end
    putmarker!(r)
end