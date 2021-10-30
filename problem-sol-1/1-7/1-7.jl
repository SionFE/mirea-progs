import HorizonSideRobots: HorizonSide, Robot, move!, isborder, putmarker!
mutable struct Coord
    x::Int
    y::Int
    Coord()=new(0,0)
    Coord(x::Int, y::Int)=new(x,y)
end
mutable struct CRobot
    robot::Robot
    loc::Coord
    CRobot(r::Robot)=new(r, Coord())
    CRobot(r::Robot, xy::Tuple{Int, Int})=new(r, Coord(xy[1],xy[2]))
end
function inttosideconverter(b)
    return HorizonSide(abs(b%4))
end
get_coord(coord::Coord)=(coord.x, coord.y)
function reverse(side)
    return HorizonSide((Int(side)+2)%4)
end
function move_for_steps!(r::CRobot, steps, side)
    for i in 1:steps
        move!(r, side)
    end
end
function moveback!(r::CRobot)
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
function move!(robot::CRobot, side::HorizonSide)
    move!(robot.robot, side)
    move!(robot.loc, side)
end
function move!(coord::Coord, side::HorizonSide)
    if side==Nord
        coord.y += 1
    elseif side==Sud
        coord.y -= 1
    elseif side==Ost
        coord.x += 1
    elseif side==West
        coord.x -= 1
    end
end
function markhalf!(r, i)
    prevmarked=1
    checkdir=inttosideconverter(i-1)
    side_of_half=inttosideconverter(i)
    while !isborder(r.robot, side_of_half) || !isborder(r.robot, checkdir)
        if isborder(r.robot, checkdir)
            move!(r, side_of_half)
            checkdir=reverse(checkdir)
        else
            move!(r, checkdir)
        end
        if prevmarked==0
            putmarker!(r.robot)
            prevmarked=1
        else
            prevmarked=0
        end
    end
    moveback!(r)
end
function mark_in_chess_order!(r)
    r=CRobot(r)
    putmarker!(r.robot)
    for i in (1, 3)
        markhalf!(r, i)
    end
end