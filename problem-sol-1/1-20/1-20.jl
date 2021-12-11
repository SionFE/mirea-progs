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

mutable struct CRobotBP <: BaseRobot
    robot::Robot
    loc::Coord
    p::Vector{Int8}
    CRobotBP(r::Robot)=new(r, Coord(), Int8[])
    CRobotBP(r::Robot, xy::Tuple{Int, Int})=new(r, Coord(xy[1],xy[2]), Int[])
end

mutable struct CRobot <: BaseRobot
    robot::Robot
    loc::Coord
    CRobot(r::Robot)=new(r, Coord())
    CRobot(r::Robot, xy::Tuple{Int, Int})=new(r, Coord(xy[1],xy[2]))
end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
isborder(robot::BaseRobot, side::HorizonSide) = isborder(robot.robot, side)
putmarker!(robot::BaseRobot) = putmarker!(robot.robot)
get_coord(coord::Coord)=(coord.x, coord.y)
int_reverse(side::HorizonSide) = mod(Int(side)+2,4)
int_to_side(b::Int)=HorizonSide(abs(mod(b, 4)))
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

function move!(robot::BaseRobot, side::HorizonSide; record::Bool=true, putm=false, mark_condition::Function=a->true)
    move!(robot.robot, side)
    move!(robot.loc, side)
    if record && typeof(robot)==CRobotBP
        push!(robot.p, int_reverse(side))
    end
    if putm && mark_condition(robot)
        putmarker!(robot)
    end
end

function move_for_steps!(r::BaseRobot, steps, side; record=true)
    for i in 1:steps
        if isborder(r, side)
            return i-1
        end
        move!(r, side, record=record)
    end
    return steps
end

function get_to_coord!(r::BaseRobot, target_coords)
    coords=get_coord(r.loc)
    if coords[1]>target_coords[1]
        hdir=West
    else
        hdir=Ost
    end
    if coords[2]>target_coords[2]
        vdir=Sud
    else
        vdir=Nord
    end
    dirs=(hdir, vdir)
    for i in 1:2
        move_for_steps!(r, abs(coords[i]-target_coords[i]), dirs[i], record=false)
    end
end


function move_to_border(r, side)
    while !isborder(r, side)
        move!(r, side)
    end
end

function move_to_corner(r::BaseRobot, dir::Int)
    move_to_border(r, HorizonSide(dir))
    move_to_border(r, int_to_side(dir+1))
end

function count_h(r)
    r=CRobot(r)
    move_to_corner(r, 1)
    dir=Ost
    counter=0
    state=0
    while !isborder(r, Nord)
        while !isborder(r, dir)
            move!(r, dir)
            if isborder(r, Nord) && state==0
                state=1
            elseif !isborder(r, Nord) && state == 1
                state=0
                counter+=1
            end
        end
        dir=inverse(dir)
        move!(r, Nord)
    end
    get_to_coord!(r, (0,0))
    print(counter)
end