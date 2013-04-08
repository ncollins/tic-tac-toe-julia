# Minmax.jl - minmax AI algorithm

cache = Dict()
cache[-1] = Dict()
cache[1] = Dict()

function wipe_cache()
    cache = Dict()
    cache[-1] = Dict()
    cache[1] = Dict()
end
    

function possible_moves(board)
    out = []
    for i=1:3
        for j=1:3
            if board[i,j] == 0
                #@show j
                out = vcat(out,[(i,j)])
            end
        end
    end
    out
end

function minmax(board, player, func)
    # this needs to return the utility (for recursion)
    # and also the best move
    if has(cache, player) && has(cache[player], board)
        cache[player][board]
    else
        child_player = -1 * player
        child_func = (func == indmax) ? indmin : indmax
        if game_state(board) == :continue_game
            children = []
            for m=possible_moves(board)
                i, j = m
                child_board = move(board, player, i, j)
                util, best_move = minmax(child_board, child_player, child_func)
                children = vcat(children, [(util, m)])
            end
            # this adds the best (util, best_move) pair to the cache
            util, best_move = children[child_func([c[1] for c=children])]
            if func == indmax
                cache[player][board] = util, best_move
            end
            util, best_move
        else
            cache[player][board] = game_state(board), nothing
        end
    end
end

minmax(board, player) = minmax(board, player, indmax)


