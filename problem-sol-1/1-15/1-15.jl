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

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
isborder(robot::BaseRobot, side::HorizonSide) = isborder(robot.robot, side)
putmarker!(robot::BaseRobot) = putmarker!(robot.robot)
ismarker(robot::BaseRobot) = ismarker(robot.robot)
int_reverse(side::HorizonSide) = mod(Int(side)+2,4)
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

function move!(robot::BaseRobot, side::HorizonSide; record::Bool=true, putm=false)
    move!(robot.robot, side)
    move!(robot.loc, side)
    if record 
        push!(robot.p, int_reverse(side))
    end
    if putm
        putmarker!(robot)
    end
end

function move_to_init_pos!(r::CRobotBP)
    for i in reverse(r.p)
        move!(r, HorizonSide(i), record=false)
    end
    r.p=Vector{Int8}[]
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

function check_if_bypassable(r::CRobotBP, dir::HorizonSide)
    checkdir=left(dir)
    n=0
    prevpose=get_coord(r.loc)
    while true
        checkdir=inverse(checkdir)
        n+=1
        n=move_for_steps!(r, n, checkdir, record=false)
        if !isborder(r,dir)
            get_to_coord!(r, prevpose)
            return true, checkdir
        end
        if isborder(r, checkdir)
            break
        end
    end
    get_to_coord!(r, prevpose)
    return false, nothing
end

function bypass!(r, dir1, dir2; record=true)
    count=0
    while isborder(r, dir1)
        move!(r, dir2, record=record)
        count+=1
    end
    dir2=inverse(dir2)
    move!(r, dir1, record=record)
    while isborder(r, dir2)
        move!(r, dir1, record=record)
    end
    move_for_steps!(r, count, dir2, record=record)
end

function try_move!(r::BaseRobot, side::HorizonSide; record=true, putm=false)
    if isborder(r, side)
        c, d=check_if_bypassable(r, side)
        if c
            bypass!(r, side, d)
            if putm
                putmarker!(r)
            end
            return true
        else
            return false
        end
    else
        move!(r, side, record=record, putm=putm)
        true
    end
end

function move_till_wall(r, side; condition::Function=a->false, record=true, putm=false)
    while !isborder(r, side)
        move!(r, side, record=record, putm=putm)
        if condition(r)
            return 1
        else
            putmarker!(r)
        end
    end
end

function mark_perimeter(r)
    r=CRobotBP(r)
    while true
        if !try_move!(r, Nord)
            break
        end
    end
    putmarker!(r)
    side=West
    while true
        if move_till_wall(r, side, condition=r->ismarker(r), record=false)==1
            break
        end
        side=left(side)
    end
    move_to_init_pos!(r)
end


