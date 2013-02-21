# Tic Tac Toe in Julia 

# GAME FUNCTIONS

function make_board(N)
    # creates an empty board of size N x N
    return zeros(Int8, N, N)
end


function move(board, player, i, j)
    if board[i,j] != 0
        error("position already taken")
    else
        board[i,j] = player
    end
end


function check_victory(board)
    # checks if either of the players have won
    N, _ = size(board)
    # rows and columns
    for i=1:N
        if (abs(sum(board[i,:])) == N) || abs(sum(board[:,i])) == N
            return true
        end
    end
    # diagonals
    if abs(sum(diag(board,0))) == N || abs(sum(diag(rotl90(board),0))) == N
        return true
    end
    false
end

# DRAWING FUNCTIONS

function board_to_string(board)
    function row_to_string(row, fun)
        width = size(row)[2]
        out = ""
        for i=1:width
            out = string(out, "\t", fun(row[i]))
        end
        out
    end

    width, height = size(board)
    out = string("\t", row_to_string([string(x) for x='A':'Z']'[:,1:width], x -> x), "\n")
    for j=1:height
        out = string(out, string(j), "\t", row_to_string(board[j,:], player_to_mark), "\n")
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

function parse_input(input, rows::String, columns::String)
    if begins_with(input, "END.")
        return (0,0)
    elseif length(input) < 3 
        error()
    elseif input[3] == '.' 
        col = search(columns, input[1])
        row = search(rows, input[2])
        if (col > 0) && (row > 0)
            return (row, col)
        else
            error()
        end
    else
        error()
    end
end


function main()
    board = make_board(4)
    player = 1
    println(board_to_string(board))
    while ~check_victory(board)
        println("Enter your move:")
        input = readline(STDIN)
        if input[length(input)] == '\n'
            input = input[1:length(input)-1]
        end
        try
            command = parse_input(input, "1234", "ABCD") # WARNING: hard coded, should use join()?
            if command == (0,0)
                break
            else
                move(board, player, command[1], command[2])
            end
            println(board_to_string(board))
            player *= -1
        catch
            println("Invalid input/move")
        end
    end
    if check_victory(board)
        println(string("PLAYER ", player_to_mark(-1*player), " WINS!"))
    else
        println("GAME ABORTED")
    end
end


# OTHER / TESTING

board = make_board(4)

println(move(board, 1, 1, 1))
println("hey")
