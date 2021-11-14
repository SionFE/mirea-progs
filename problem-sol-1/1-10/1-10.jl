function reverse(side)
    return HorizonSide((Int(side)+2)%4)
end
function movetillwall(r,s)
    a=0
    b=0
    if ismarker(r)
        a+=1
        b+=temperature(r)
    end
    while !isborder(r,s)
        move!(r,s)
        if ismarker(r)
            a+=1
            b+=temperature(r)
        end
    end
    return (a,b)
end
function av_temperature(r)
    num_of_markers=0
    t_sum=0
    side=Ost
    while true
        t=movetillwall(r, side)
        num_of_markers+=t[1]
        t_sum+=t[2]
        if !isborder(r,Nord)
            move!(r,Nord)
            side=reverse(side)
        else
            break
        end
    end
    print(t_sum/num_of_markers)
end