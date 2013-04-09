# Minmax.jl - minmax AI algorithm

cache = Dict()
cache[(-1,:max)] = Dict()
cache[(-1,:min)] = Dict()
cache[(1,:max)] = Dict()
cache[(1,:min)] = Dict()

function wipe_cache()
    cache = Dict()
    cache[(-1,:max)] = Dict()
    cache[(-1,:min)] = Dict()
    cache[(1,:max)] = Dict()
    cache[(1,:min)] = Dict()
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


function minmax(board, player, status)
    func = (status == :max) ? indmax : indmin
    # this needs to return the utility (for recursion)
    # and also the best move
    if has(cache, (player, status)) && has(cache[(player, status)], board)
        cache[(player, status)][board]
    else
        child_player = -1 * player
        child_status = (status == :max) ? (:min) : (:max)
        child_func = (child_status == :max) ? indmax : indmin
        if game_state(board) == :continue_game
            children = []
            for next_move=possible_moves(board)
                child_board = move(board, player, next_move)
                util, _ = minmax(child_board, child_player, child_status)
                children = vcat(children, [(util, next_move)])
            end
            # this adds the best (util, best_move) pair to the cache
            #util, chosen_move = children[child_func([c[1] for c=children])]
            util, chosen_move = children[func([c[1] for c=children])]
            cache[(player, status)][board] = util, chosen_move
            util, chosen_move
        else
            cache[(player, status)][board] = game_state(board), nothing
        end
    end
end

minmax(board, player) = minmax(board, player, :max)
