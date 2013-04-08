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


function minmax_with_cache(board, player, status)
    func = (status == :max) ? indmax : indmin
    # this needs to return the utility (for recursion)
    # and also the best move
    if has(cache, player) && has(cache[player], board)
        cache[player][board]
    else
        child_player = -1 * player
        child_status = (status == :max) ? (:min) : (:max)
        child_func = (child_status == :max) ? indmax : indmin
        if game_state(board) == :continue_game
            children = []
            for next_move=possible_moves(board)
                child_board = move(board, player, next_move)
                util, _ = minmax_with_cache(child_board, child_player, child_status)
                children = vcat(children, [(util, next_move)])
            end
            # this adds the best (util, best_move) pair to the cache
            util, chosen_move = children[child_func([c[1] for c=children])]
            if status == :max
                cache[player][board] = util, chosen_move
            end
            util, chosen_move
        else
            cache[player][board] = game_state(board), nothing
        end
    end
end

minmax_with_cache(board, player) = minmax_with_cache(board, player, :max)
