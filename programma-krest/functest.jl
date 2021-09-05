function cross(r)
    side=[West, Ost, Nord, Sud]
    for i in (HorizonSide(s) for s in 0:3)
        while isborder(r,i)==false
            move!(r,i)
            putmarker!(r)
        end
        while ismarker(r)==true
            move!(r,HorizonSide((Int(i)+2)%4))
        end
    end
    putmarker!(r)
end