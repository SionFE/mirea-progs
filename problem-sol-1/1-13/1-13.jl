using HorizonSideRobots: HorizonSide
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

isborder(robot::BaseRobot, side::HorizonSide) = isborder(robot.robot, side)
putmarker!(robot::BaseRobot) = putmarker!(robot.robot)
int_to_side(b::Int)=HorizonSide(abs(mod(b, 4)))
get_coord(coord::Coord)=(coord.x, coord.y)

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

function move!(robot::BaseRobot, side::HorizonSide; putmarker::Bool=false)
    move!(robot.robot, side)
    move!(robot.loc, side)
    if putmarker
        putmarker!(r)
    end
end

function diagmove(r::BaseRobot, dir::Int; putmarker::Bool=false)
    move!(r, HorizonSide(dir))
    move!(r, int_to_side(dir+1))
    if putmarker
        putmarker!(r)
    end
end

function move_for_steps!(r::CRobot, steps, side)
    for i in 1:steps
        move!(r, side)
    end
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

function diagcross(r)
    r=CRobot(r)
    putmarker!(r)
    for i in 0:3
        while !isborder(r, HorizonSide(i)) && !isborder(r, int_to_side(i+1))
            diagmove(r, i, putmarker=true)
        end
        moveback!(r)
    end
end
