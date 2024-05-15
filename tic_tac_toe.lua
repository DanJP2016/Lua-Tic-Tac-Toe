math.randomseed(os.time())

local board = {}
local avail_moves = {}
local turn = 'X'
local player_letter = nil
local ai_letter = nil
local winner = nil

function search(val, tbl)
  assert(type(tbl) == 'table')

  for i = 1, #tbl do
    if tbl[i] == val then
      return true
    end
  end

  return false
end

function copyTbl(tbl)
  local copy = {}

  for i = 1, #tbl do
    table.insert(copy, tbl[i])
  end

  return copy
end

function check_win(letter, board)
  if board[5] == letter then
    if board[1] == letter and board[9] == letter then
      return true
    elseif board[3] == letter and board[7] == letter then
      return true
    elseif board[4] == letter and board[6] == letter then
      return true
    elseif board[2] == letter and board[8] == letter then
      return true
    end
  end

  if board[1] == letter then
    if board[1] == letter then
      if board[2] == letter and board[3] == letter then
        return true
      elseif board[4] == letter and board[7] == letter then
        return true
      end
    end
  end

  if board[9] == letter then
    if board[7] == letter and board[8] == letter then
      return true
    elseif board[3] == letter and board[6] == letter then
      return true
    end
  end

  return false
end

function get_open_squares(tbl)
  local open = 0
  for i = 1, #tbl do
    if tbl[i] ~= player_letter and tbl[i] ~= ai_letter then
      open = open + 1
    end
  end

  return open
end

function check_tie(board)
  if get_open_squares(board) == 0 then
    return true
  end

  return false
end

function create_board()
  for i = 1, 9 do
    table.insert(board, i)
  end
end

function print_board()
  print('current game board')
  for i = 1, 7, 3 do
    print('| ' .. board[i] .. ' | ' .. board[i + 1] .. ' | ' .. board[i + 2] .. ' |')
  end
end

function get_avail()
  -- clear avail_moves
  avail_moves = {}

  for i = 1, #board do
    if type(board[i]) == 'number' then
      table.insert(avail_moves, board[i])
    end
  end
end

function choose_letter()
  local choice
  local choices = {1, 2}
  print('please choose your letter: ')
  print('1: X')
  print('2: 0')

  choice = io.read()
  choice = tonumber(choice)

  if type(choice) ~= 'number' or choices[choice] == nil then
    repeat
      print('invalid choice...')

      print('please choose your letter: ')
      print('1: X')
      print('2: 0')
      choice = io.read()
      choice = tonumber(choice)
    until choices[choice] ~= nil
  end

  if choice == 1 then
    print('you choose X')
    player_letter = 'X'
    ai_letter = 'O'
  else
    print('you choose O')
    player_letter = 'O'
    ai_letter = 'X'
  end
end

function get_player_move()
  print('player move')
  local val

  print('Player ' .. player_letter .. ' Make Your Move...')
  val = io.read()
  val = tonumber(val)

  if type(val) ~= 'number' or val > 9 or val < 1 or search(val, avail_moves) == false then
    repeat
      print('Invalid Move, enter a valid number: (1-9)')
      val = io.read()
      val = tonumber(val)

    until type(val) == 'number' and val <= 9 and val >= 1 and search(val, avail_moves) == true
  end

  return val
end

function simple_ai_move()
  local val

  if #avail_moves == 1 then
    return avail_moves[1]
  end

  val = avail_moves[math.random(1, #avail_moves)]

  if type(tonumber(board[val])) ~= 'number' then
    repeat
      val = avail_moves[math.random(1, #avail_moves)]
    until type(tonumber(board[val])) == 'number'
  end

  return val
end

function minimax(state, max)
  if check_win(ai_letter, state) then
    return 999
  end

  if check_win(player_letter, state) then
    return -999
  end

 if check_tie(state) then
   return 0
 end

  if max == true then
    local best = -999
    for i = 1, #board do
      if state[i] ~= ai_letter and state[i] ~= player_letter then
        local tmp = state[i]
        state[i] = ai_letter
        local score = minimax(state, false)
        best = math.max(score, best)
        state[i] = tmp
      end
    end
    return best
  elseif max == false then
    local best = 999
    for i = 1, #board do
      if state[i] ~= ai_letter and state[i] ~= player_letter then
        local tmp = state[i]
        state[i] = player_letter
        local score = minimax(state, true)
        best = math.min(score, best)
        state[i] = tmp
      end
    end
    return best
  end
end

function best_ai_move()
  local state = copyTbl(board)
  local eval = -999
  local move_eval = 0
  local best_move = 0
  local move = nil

  for i = 1, #state do
    if state[i] ~= ai_letter and state[i] ~= player_letter then
      move = state[i]
      state[i] = ai_letter
      move_eval = minimax(state, false)
      state[i] = move
      if move_eval > eval then
        best_move = move
      end
    end
  end

  return best_move
end

function update_board(move, letter)
  assert(type(move) == 'number')
  assert(letter == 'X' or letter == 'O')
  board[move] = letter

  get_avail()
  print_board()
end

function make_move(board)
  local move

  if turn == player_letter then
    move = get_player_move()
  else
    -- move = simple_ai_move()
    move = best_ai_move()
  end

  update_board(move, turn)
end

function next_turn()
  turn = turn == player_letter and ai_letter or player_letter
end

function play_game()
  create_board()
  get_avail()
  choose_letter()
  print_board()

  repeat
    if #avail_moves > 0 then
      make_move(board)

      if check_win(turn, board) == true then
        print(turn .. ' WINS !')
        winner = true
      elseif check_tie(board) == true then
        print('TIE !')
        winner = false
      end

      next_turn()
    end
  until winner ~= nil or #avail_moves == 0
end

play_game()
