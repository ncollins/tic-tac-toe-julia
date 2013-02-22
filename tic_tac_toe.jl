# Tic Tac Toe in Julia 

# GAME FUNCTIONS

function make_board(N)
    # creates an empty board of size N x N
    rows = [char(x+48) for x=1:N]
    columns = [x for x='A':'Z'][1:N]
    return zeros(Int8, N, N), rows, columns
end


function move(board, player, i, j)
    if board[i,j] != 0
        error("position already taken")
    else
        board[i,j] = player
    end
end


function game_state(board)
    # returns 0 if the game is ongoing
    # 1 if player X has won
    # -1 if player O has won
    # 2 if there are no more moves
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
        return 2
    end
    # game continues
    return 0
end

# DRAWING FUNCTIONS

function board_to_string(board, rows, columns)
    function row_to_string(row, fun)
        out = ""
        for i=row
            out = string(out, "\t", fun(i))
        end
        out
    end

    width, height = size(board)
    out = string("\t", row_to_string([x for x=columns], string), "\n")
    for j=1:height # use this rather than 'rows' as we need an integer index
        row_seq = [x for x=board[j,:]]
        out = string(out, string(j), "\t", row_to_string(row_seq, player_to_mark), "\n")
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
    if input[3] == '\n' 
        col = findin(columns, input[1])[1]
        row = findin(rows, input[2])[1]
        if (col > 0) && (row > 0)
            return (row, col)
        else
            error()
        end
    elseif input == "END\n"
        return (0,0)
    else
        error()
    end
end


function main()
    board, rows, columns = make_board(3)
    player = 1
    println(board_to_string(board, rows, columns))
    while game_state(board) == 0
        println("Enter your move:")
        input = readline(STDIN)
        try
            command = parse_input(input, rows, columns)
            if command == (0,0)
                break
            else
                move(board, player, command[1], command[2])
            end
            println(board_to_string(board, rows, columns))
            player *= -1
        catch
            println("Invalid input/move")
        end
    end
    if game_state(board) == 1
        println(string("PLAYER A (Xs) WINS!"))
    elseif game_state(board) == -1
        println(string("PLAYER B (Os) WINS!"))
    elseif game_state(board) == 2
        println("GAME OVER: NO MOVES AVAILABLE")
    else
        println("GAME ABORTED")
    end
end
