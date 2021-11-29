import HorizonSideRobots: move!, isborder, putmarker!, temperature, ismarker, Robot

abstract type BaseRobot
end

mutable struct Coord
    x::Int
    y::Int
    Coord()=new(0,0)
    Coord(x::Int, y::Int)=new(x,y)
end

mutable struct CRobot <: BaseRobot
    robot::Robot
    loc::Coord
    CRobot(r::Robot)=new(r, Coord())
    CRobot(r::Robot, xy::Tuple{Int, Int})=new(r, Coord(xy[1],xy[2]))
end

get_coord(coord::Coord)=(coord.x, coord.y)
int_to_side(b::Int)=HorizonSide(abs(mod(b, 4)))
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
isborder(robot::BaseRobot, side::HorizonSide) = isborder(robot.robot, side)
putmarker!(robot::BaseRobot) = putmarker!(robot.robot)
ismarker(robot::BaseRobot) = ismarker(robot.robot)

function move!(coord::Coord, side::HorizonSide)
    if side==Nord
        coord.y += 1
    elseif side==Sud
        coord.y -= 1
    elseif side==Ost
        coord.x += 1
    else
        coord.x -= 1
    end
end

function move!(robot::BaseRobot, side::HorizonSide)
    move!(robot.robot, side)
    move!(robot.loc, side)
end

function movetillwall!(r, side)
    while !isborder(r, side)
        move!(r, side)
    end
end

function move_for_steps!(r::CRobot, steps, side)
    for i in 1:steps
        move!(r, side)
    end
end

function movetocorner(r, corner) #0 - Северо-западный угол, 1 - Ю-З, 2 - Ю-В, 3 - С-В)
    countNord=movetillwall!(r, HorizonSide(corner))
    countWest=movetillwall!(r, int_to_side(corner+1))
end

function moveback!(r::BaseRobot)
    coords=get_coord(r.loc)
    if coords[1]>0
        hdir=West
    else
        hdir=Ost
    end
    if coords[2]>0
        vdir=Sud
    else
        vdir=Nord
    end
    dirs=(hdir, vdir)
    for i in 1:2
        move_for_steps!(r, abs(coords[i]), dirs[i])
    end
end

function markv(c, mark, n)
    if c==n
        return false
    elseif c==0
        return true
    else
        return mark
    end
end

function HorizMark(r, n, markifalse, side, count, mark)
    while true
        if mark
            if !markifalse
                putmarker!(r)
            end
            count+=1
        else
            if markifalse
                putmarker!(r)
            end
            count-=1
        end
        if isborder(r,side)
            count=n-count
            side=inverse(side)
            break
        end
        move!(r, side)
        mark=markv(count, mark,n)
    end
    return (side, count, mark)
end

function corner_check(r, side1, side2)
    if isborder(r, side1) && isborder(r, side2)
        return true
    else
        false
    end
end

function invmark(rc::Int, n::Int)
    if mod(div(rc,n), 2)==0
        return false
    else
        return true
    end
end

function chess_mark_advanced(r::Robot, n::Int)
    r=CRobot(r)
    rc=0
    movetocorner(r, 1)
    side=Ost
    data=(side, 0, true)
    while true
        data=HorizMark(r, n, invmark(rc, n), data[1], data[2], data[3])
        if !isborder(r, Nord)
            move!(r, Nord)
            rc+=1
        else
            break
        end
    end
    moveback!(r)
end



