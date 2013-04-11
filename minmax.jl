# Minmax.jl - minmax AI algorithm

cache = Dict()

function wipe_cache()
    cache = Dict()
end
    

function possible_moves(board)
    N, _ = size(board)
    out = []
    for i=1:N
        for j=1:N
            if board[i,j] == 0
                out = vcat(out,[(i,j)])
            end
        end
    end
    out
end


function minmax(board, player)
    func = (player == 1) ? indmax : indmin
    # this needs to return the utility (for recursion)
    # and also the best move
    if has(cache, string(board))
        cache[string(board)]
    else
        child_player = -1 * player
        if game_state(board) == :continue_game
            children = []
            for next_move=possible_moves(board)
                child_board = move(board, player, next_move)
                util, _ = minmax(child_board, child_player)
                children = vcat(children, [(util, next_move)])
            end
            util, chosen_move = children[func([c[1] for c=children])]
            cache[string(board)] = util, chosen_move
            util, chosen_move
        else
            cache[string(board)] = game_state(board), nothing
        end
    end
end
