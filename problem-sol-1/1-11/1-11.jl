import HorizonSideRobots: HorizonSide, Robot, move!, isborder, putmarker!
function int_reverse(side)
    return (Int(side)+2)%4
end


function inttosideconverter(b)
    return HorizonSide(abs(b%4))
end


mutable struct Coord
    x::Int
    y::Int
    Coord()=new(0,0)
    Coord(x::Int, y::Int)=new(x,y)
end


mutable struct CRobotBP #CRobotBP - робот с backpath, т.е. с обратным путём. p хранит обратный путь в виде направлений движений
    robot::Robot
    loc::Coord
    p::Vector{Int8}
    CRobotBP(r::Robot)=new(r, Coord(), Int8[])
    CRobotBP(r::Robot, xy::Tuple{Int, Int})=new(r, Coord(xy[1],xy[2]), Int[])
end


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


function move!(robot::CRobotBP, side::HorizonSide; record::Bool=true)
    move!(robot.robot, side)
    move!(robot.loc, side)
    if record
        push!(robot.p, int_reverse(side))
    end
end


isborder(r::CRobotBP, side::HorizonSide)=isborder(r.robot, side)
get_coord(coord::Coord)=(coord.x, coord.y)
putmarker!(r::CRobotBP)=putmarker!(r.robot)


function move_to_init_pos!(r::CRobotBP)
    for i in reverse(r.p)
        move!(r, HorizonSide(i), record=false)
    end
    r.p=Vector{Int8}[]
end


function movetillwall!(r,s; rec=true)
    while !isborder(r,s)
        move!(r,s,record=rec)
    end
end


function move_for_steps!(r::CRobotBP, side, steps; rec=true)
    for i in 1:steps
        move!(r, side, record=rec)
    end
end


function check_if_bypassable(r::CRobotBP)
    movedir=West
    while !isborder(r.robot,movedir)
        move!(r,movedir,record=false)
        if !isborder(r,Nord)
            movedir=HorizonSide(int_reverse(movedir))
            for i=1:abs(get_coord(r.loc)[1])
                move!(r, movedir,record=false)
            end
            return true
        end
    end
    movedir=HorizonSide(int_reverse(movedir))
    for i=1:abs(get_coord(r.loc)[1])
        move!(r, movedir,record=false)
    end
    return false
end


function move_till_!obstacle(r,s)
    while isborder(r,s)
        move!(r, inttosideconverter(Int(s)+1))
    end
    move!(r,s)
end


function bypass!(r)
    for i=0:1
        move_till_!obstacle(r, inttosideconverter(4-i))
    end
    for i=1:abs(get_coord(r.loc)[1])
        move!(r, Ost)
    end
end


function startmarking!(r)
    for i=1:4
        movetillwall!(r, inttosideconverter(i), rec=false)
        if i%2==0
            move_for_steps!(r, inttosideconverter(i+1), abs(get_coord(r.loc)[1]), rec=false)
        else
            move_for_steps!(r, inttosideconverter(i+1), abs(get_coord(r.loc)[2]), rec=false)
        end
        putmarker!(r)
    end
end


function markerbordercross!(r::Robot)
    r=CRobotBP(r)
    while true
        movetillwall!(r, Nord)
        if !check_if_bypassable(r)
            break
        end
        bypass!(r)
    end
    println(r.p)
    startmarking!(r)
    move_to_init_pos!(r)
end