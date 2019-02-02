# Tic Tac Toe in Julia 

using LinearAlgebra
include("minmax.jl")

# GAME FUNCTIONS

function make_board(N)
    # creates an empty board of size N x N
    rows = [Char(x+48) for x=1:N]
    columns = [x for x='A':'Z'][1:N]
    return zeros(Int, N, N), rows, columns
end


function move(board, player, position)
    b = copy(board)
    i, j = position
    if b[i,j] != 0
        error("position already taken")
    else
        b[i,j] = player
    end
    b
end


function game_state(board)
    # returns :continue_game if the game is ongoing
    # 1 if player X has won
    # -1 if player O has won
    # 0 if there are no more moves
    N, _ = size(board)
    # rows and columns
    for i=1:N
        if sum(board[i,:]) == N || sum(board[:,i]) == N
            return 1
        elseif sum(board[i,:]) == -N || sum(board[:,i]) == -N
            return -1
        end
    end
    # diagonals
    if sum(diag(board,0)) == N || sum(diag(rotl90(board),0)) == N
        return 1
    elseif sum(diag(board,0)) == -N || sum(diag(rotl90(board),0)) == -N
        return -1
    elseif ~any(x -> x==0, board)
        return 0
    end
    # game continues
    return :continue_game
end

# DRAWING FUNCTIONS

function board_to_string(board, rows, columns)
    function row_to_string(row, fun)
        local out = ""
        for i=row
            out = string(out, "\t", fun(i))
        end
        out
    end

    width, height = size(board)
    out = string("\t", row_to_string([x for x=columns], string), "\n")
    for j=1:height # use this rather than 'rows' as we need an integer index
        row_seq = [x for x=board[j,:]]
        row_string = row_to_string(row_seq, player_to_mark)
        out = string(out, string(j), "\t", row_string, "\n")
    end
    out
end


function player_to_mark(x)
    if x == -1
        out = "O"
    elseif x == 1
        out = "X"
    else
        out = " "
    end
    out
end


# PLAY GAME

function parse_input(input, rows, columns)
    if length(input) == 2
		col = findfirst(x -> x == input[1], columns)
        row = findfirst(x -> x == input[2], rows)
        if (col > 0) && (row > 0)
            return (row, col)
        else
            error()
        end
    elseif input == "END"
        return (0,0)
    else
        error()
    end
end


function get_player_status(player)
    player_string = (player == 1) ? "X" : "O"
    println("Player $player_string: (H)uman or (C)omputer?")
		input = readline(stdin)
    if input == "H"
        :human
    elseif input == "C"
        :computer
    else
        println("Chose 'H' for Human or 'C' for Computer...")
        get_player_status(player)
    end
end


function main()
    # setup game and first player
    board, rows, columns = make_board(3)
    player = 1
    # get player status Human or Computer
    players = [1, -1]
    player_type = Dict()
    for p=players
        player_type[p] = get_player_status(p)
    end
    # main game loop
    while game_state(board) == :continue_game
        println(board_to_string(board, rows, columns))
        if player_type[player] == :human
            println("Enter your move:")
            input = readline(stdin)
            try
                command = parse_input(input, rows, columns)
                if command == (0,0)
                    break
                else
                    board = move(board, player, command)
                end
                player *= -1
            catch
                println("Invalid input/move")
            end
        else
            ai_util, ai_move = minmax(board, player)
            board = move(board, player, ai_move)
            player *= -1
        end
    end
    if game_state(board) == 1
        println(board_to_string(board, rows, columns))
        println(string("PLAYER A (Xs) WINS!"))
    elseif game_state(board) == -1
        println(board_to_string(board, rows, columns))
        println(string("PLAYER B (Os) WINS!"))
    elseif game_state(board) == 0
        println(board_to_string(board, rows, columns))
        println("GAME OVER: NO MOVES AVAILABLE")
    else
        println("GAME ABORTED")
    end
end


main()
