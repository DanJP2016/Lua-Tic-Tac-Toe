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

function check_win(letter)
  if board[5] == letter then
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

  if board[3] == letter then
    if board[3] == letter then
      if board[6] == letter and board[9] == letter then
        return true
      end
    end
  end

  if board[7] == letter then
    if board[7] == letter then
      if board[8] == letter and board[9] == letter then
        return true
      end
    end
  end

  return false
end

function check_tie()
  if #avail_moves == 0 then
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
      -- print(choice)
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

  -- if #avail_moves <= 0 then
  --   return
  -- end

  if #avail_moves == 1 then
    return avail_moves[1]
  end

  val = avail_moves[math.random(1, #avail_moves)]

  -- hangs when only 2 moves left ; maybe fixed?
  print(table.concat(avail_moves, ','))
  if type(tonumber(board[val])) ~= 'number' then
    repeat
      val = avail_moves[math.random(1, #avail_moves)]
    until type(tonumber(board[val])) == 'number'
  end

  return val
end

function update_board(move, letter)
  assert(type(move) == 'number')
  assert(letter == 'X' or letter == 'O')
  board[move] = letter

  -- update avail moves
  get_avail()

  -- print new board
  print_board()
end

function make_move()
  local move

  if turn == player_letter then
    move = get_player_move()
  else
    move = simple_ai_move()
  end

  update_board(move, turn)
end

-- set turn for next player
function next_turn()
  -- set turn for next player
  turn = turn == player_letter and ai_letter or player_letter
end

function play_game()
  create_board()
  get_avail()

  choose_letter()

  print_board()

  repeat
    if #avail_moves > 0 then
      make_move()

      if check_win(turn) == true then
        print(turn .. ' WINS !')
        winner = true
      elseif check_tie() == true then
        print('TIE !')
        winner = false
      end

      next_turn()
    end
  until winner ~= nil or #avail_moves == 0
end

play_game()
