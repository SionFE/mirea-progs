function inttosideconverter(b)
    return HorizonSide(abs(b%4))
end
function spiral(r)
    n=1
    side=0
    status=0
    while status==0
        for i in 1:n
            if ismarker(r)==true
                status=1
                break
            end
            move!(r, inttosideconverter(side))
        end
        side+=1
        if side%2==0
            n+=1
        end
    end
end


