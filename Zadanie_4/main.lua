local
function newButton(text, fn)
    return {
        text = text,
        fn = fn,

        now = false,
        last = false
    }
end

local buttons = {}
local pauseButtons = {}
local font = nil

function love.load()
    love.window.setMode(270, 452)
    love.window.setTitle("Tetris")
    love.graphics.setBackgroundColor(0,0,0)

    sounds = {}
    sounds.blip = love.audio.newSource("sounds/blip.wav", "static")
    sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
    sounds.music:setLooping(true)

    sounds.music:play()

    scenes = {
        game = love.graphics.newCanvas(),
        startMenu = love.graphics.newCanvas(),
        pause = love.graphics.newCanvas(),
        endGame = love.graphics.newCanvas()
    }

    states = {
        inGame = false,
        inStartMenu = true,
        inPause = false,
        inEndGame = false
    }

    maxWidth = 20
    maxHeight = 29
    startXpos = 1
    startYpos = 9
    stopTime = 0.5
    stopTime1 = 0.1
    rollTime = 0.25
    shape_choosed = false
    rolltype = 2
    points = 0

    board = {}
    for i=1, maxHeight do
        board[i] = {}
        for j=1, maxWidth do
            if j == 1 or j == maxWidth or i == maxHeight then
                board[i][j] = -1
            else
                board[i][j] = 0
            end
        end
    end

    shapes = {
        {
            {
                {true, true, true, true},
                {false, false, false, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {255, 0, 0}
            },

            {
                {true, false, false, false},
                {true, false, false, false},
                {true, false, false, false},
                {true, false, false, false},
                color = {255, 0, 0}
            }
        },

        {
            {
                {false, true, false, false},
                {false, true, false, false},
                {true, true, false, false},
                {false, false, false, false},
                color = {0, 255, 0}
            },
            
            {
                {true, false, false,false},
                {true, true, true, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {0, 255, 0}
            },

            {
                {true, true, true,false},
                {false, false, true, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {0, 255, 0}
            },

            {
                {true, true, false,false},
                {true, false, false, false},
                {true, false, false, false},
                {false, false, false, false},
                color = {0, 255, 0}
            }
        },

        {
            {
                {true, false, false,false},
                {true, false, false, false},
                {true, true, false, false},
                {false, false, false, false},
                color = {255, 160, 0}
            },

            {
                {true, true, true,false},
                {true, false, false, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {255, 160, 0}
            },

            {
                {false, false, true,false},
                {true, true, true, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {255, 160, 0}
            },

            {
                {true, true, false,false},
                {false, true, false, false},
                {false, true, false, false},
                {false, false, false, false},
                color = {255, 160, 0}
            }
        },

        {
            {
                {true, true, false,false},
                {true, true, false, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {128, 0, 128}
            }
        },

        {
            {
                {false, true, false,false},
                {true, true, true, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {0, 0, 255}
            },

            {
                {true, false, false,false},
                {true, true, false, false},
                {true, false, false, false},
                {false, false, false, false},
                color = {0, 0, 255}
            },

            {
                {true, true, true,false},
                {false, true, false, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {0, 0, 255}
            },

            {
                {false, true, false,false},
                {true, true, false, false},
                {false, true, false, false},
                {false, false, false, false},
                color = {0, 0, 255}
            }
        },

        {
            {
                {false, true, false,false},
                {true, true, false, false},
                {true, false, false, false},
                {false, false, false, false},
                color = {255, 255, 0}
            },

            {
                {true, true, false,false},
                {false, true, true, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {255, 255, 0}
            }
        },

        {
            {
                {false, true, true,false},
                {true, true, false, false},
                {false, false, false, false},
                {false, false, false, false},
                color = {165, 42, 42}
            },

            {
                {true, false, false,false},
                {true, true, false, false},
                {false, true, false, false},
                {false, false, false, false},
                color = {165, 42, 42}
            }
        }
    }

    font = love.graphics.newFont(24)
    table.insert(buttons, newButton(
        "Start Game",
        function()
            states.inStartMenu = false
            states.inGame = true
        end
    ))
    table.insert(buttons, newButton(
        "Load Game",
        load_game
    ))
    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end
    ))

    table.insert(pauseButtons, newButton(
        "Resume",
        function()
            states.inPause = false
            states.inGame = true
        end
    ))
    table.insert(pauseButtons, newButton(
        "Save",
        save_game
    ))
    table.insert(pauseButtons, newButton(
        "Load Game",
        load_game
    ))
    table.insert(pauseButtons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end
    ))

end

function draw_shape(x, y, shape, color)
    love.graphics.setCanvas(scenes.game)
    for i=1, 4 do
        for j=1, 4 do
            if shape[i][j] == true then
                love.graphics.setColor(love.math.colorFromBytes(color))
                love.graphics.rectangle("fill", (j-1)*15+(y-1)*15-15, (i-1)*15+(x-1)*15+32, 15, 15)
                love.graphics.setLineWidth(2)
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("line", (j-1)*15+(y-1)*15-15, (i-1)*15+(x-1)*15+32, 15, 15)
            end
        end
    end
    love.graphics.setCanvas()
end

function erase_shape(x, y, shape)
    love.graphics.setCanvas(scenes.game)
    for i=1, 4 do
        for j=1, 4 do
            if shape[i][j] == true then
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("fill", (j-1)*15+(y-1)*15-15, (i-1)*15+(x-1)*15+32, 15, 15)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", (j-1)*15+(y-1)*15-15, (i-1)*15+(x-1)*15+32, 15, 15)
            end
        end
    end
    love.graphics.setCanvas()
end

function check_move_down(x, y, shape)
    for i=1, 4 do
        for j=1, 4 do
            if shape[i][j] == true then
                if board[i+x-1+1][j+y-1] ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

function check_left_side(x, y, shape)
    for i=1, 4 do
        for j=1, 4 do
            if shape[i][j] == true then
                if board[i+x-1][j-1+y-1] ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

function check_right_side(x, y, shape)
    for i=1, 4 do 
        for j=1, 4 do
            if shape[i][j] == true then
                if board[i+x-1][j+1+y-1] ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

function save_block(x, y, shape, id)
    for i=1, 4 do
        for j=1, 4 do
            if shape[i][j] == true then
                if id == 1 then
                    board[i+x-1][j+y-1] = 1
                end
                if id == 2 then
                    board[i+x-1][j+y-1] = 2
                end
                if id == 3 then
                    board[i+x-1][j+y-1] = 3
                end
                if id == 4 then
                    board[i+x-1][j+y-1] = 4
                end
                if id == 5 then
                    board[i+x-1][j+y-1] = 5
                end
                if id == 6 then
                    board[i+x-1][j+y-1] = 6
                end
                if id == 7 then
                    board[i+x-1][j+y-1] = 7
                end
            end
        end
    end            
end

function draw_board1()
    love.graphics.setCanvas(scenes.game)
    for i=1, maxHeight do
        for j=1, maxWidth do
            love.graphics.setColor(love.math.colorFromBytes(0, 41, 58))
            love.graphics.rectangle("fill", j*15-15, i*15-17, 15, 15)
            love.graphics.setColor(255, 255, 255)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", j*15-15, i*15-17, 15, 15)
        end
    end
    love.graphics.setgames()
end

function draw_info()
    local font = love.graphics.newFont(18)
    love.graphics.setCanvas(scenes.game)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", 1, 1, 268, 30)
    love.graphics.print("Points: ", font, 80, 5)
    love.graphics.print(tostring(points), font, 170, 6)
    love.graphics.setCanvas()
end

function draw_menu(buttonsTable, canva)
    love.graphics.setCanvas(canva)
    local width_ = love.graphics.getWidth()
    local height_ = love.graphics.getHeight()

    local button_width = width_ * (2/3)
    local margin = 30

    local total_height = (60 + margin) * table.getn(buttonsTable)
    local cursor_y = 0

    for i, button in ipairs(buttonsTable) do
        button.last = button.now

        local bx = (width_ * 0.5) - (button_width * 0.5)
        local by = (height_ * 0.5) - (total_height * 0.5) + cursor_y

        local color = {0.4, 0.4, 0.5, 1.0}
        local mousex, mousey = love.mouse.getPosition()

        local hot = mousex > bx and mousex < bx + button_width and 
                    mousey > by and mousey < by + 60

        if hot then
            color = {0.8, 0.8, 0.9, 1.0}
        end

        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            button_width,
            60
        )

        love.graphics.setColor(255, 255, 255, 1.0)

        local textWidth = font:getWidth(button.text)
        local textHeight = font:getHeight(button.text)
        love.graphics.print(
            button.text,
            font,
            (width_ * 0.5) - textWidth * 0.5,
            by + textHeight * 0.5
        )

        cursor_y = cursor_y + (60 + margin)
    end

    local font_instruction = love.graphics.newFont(11)
    love.graphics.setColor(255, 255, 255, 1.0)
    love.graphics.print("move left: (<-)", font_instruction, 10, 410)
    love.graphics.print("move right: (->)", font_instruction, 10, 430)
    love.graphics.print("roll block: (r)", font_instruction, 165, 410)
    love.graphics.print("pause game: (p)", font_instruction, 165, 430)

    love.graphics.setCanvas()
end

function draw_board()
    love.graphics.setCanvas(scenes.game)
    for i=1, maxHeight do
        for j=1, maxWidth do
            if board[i][j] ~= 0 and board[i][j] ~= -1 then
                if board[i][j] == 1 then
                    love.graphics.setColor(love.math.colorFromBytes(255, 0, 0)) 
                elseif board[i][j] == 2 then
                    love.graphics.setColor(love.math.colorFromBytes(0, 255, 0)) 
                elseif board[i][j] == 3 then
                    love.graphics.setColor(love.math.colorFromBytes(255, 160, 0)) 
                elseif board[i][j] == 4 then
                    love.graphics.setColor(love.math.colorFromBytes(128, 0, 128)) 
                elseif board[i][j] == 5 then
                    love.graphics.setColor(love.math.colorFromBytes(0, 0, 255)) 
                elseif board[i][j] == 6 then
                    love.graphics.setColor(love.math.colorFromBytes(255, 255, 0)) 
                elseif board[i][j] == 7 then
                    love.graphics.setColor(love.math.colorFromBytes(165, 42, 42)) 
                end
                love.graphics.rectangle("fill", j*15-30, i*15+17, 15, 15)
                love.graphics.setLineWidth(2)
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("line", j*15-30, i*15+17, 15, 15)
            else
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("fill", j*15-30, i*15+17, 15, 15)
            end
        end
    end
    love.graphics.setCanvas()
end

function save_game()
    local file, err = io.open("savedGame.txt", 'w+')
    if file then
        for i=1, maxHeight do
            for j=1, maxWidth do
                file:write(tostring(board[i][j]).." ")
            end
            file:write("\n")
        end

        if current_block ~= nil then
            for i=1, 4 do
                for j=1, 4 do
                    file:write(tostring(current_block[1][i][j]).." ")
                end
                file:write("\n")
            end

            file:write(tostring(current_block[1].color[1]).." ")
            file:write(tostring(current_block[1].color[2]).." ")
            file:write(tostring(current_block[1].color[3]))
        end

        file:write("\n")
        file:write(tostring(startXpos).." ")
        file:write(tostring(startYpos))
        file:write("\n")
        file:write(tostring(gen))

    else
        print("error", err)
    end

    file:close()
end

function convert_string_to_boolean(string)
    if string == "true" then
        return true
    else
        return false
    end
end

function load_game()
    local file, err = io.open("savedGame.txt", 'r')
    local line_number = 1
    local word_number = 1
    local gen = nil
    local shape_ = {}
    if file then
        for line in file:lines() do
            local row = {}
            for word in line:gmatch("%-?%w+") do
                if line_number <= 29 then
                    board[line_number][word_number] = tonumber(word)
                elseif line_number >= 30 and line_number <= 33 then
                    table.insert(row, convert_string_to_boolean(word))
                elseif line_number == 34 then
                    table.insert(row, tonumber(word))
                elseif line_number == 35 and word_number == 1 then
                    startXpos = tonumber(word)
                elseif line_number == 35 and word_number == 2 then
                    startYpos = tonumber(word)  
                else
                    gen = tonumber(word)
                end
                word_number = word_number+1        
            end

            if line_number >= 30 and line_number <= 33 then
                table.insert(shape_, row)
            elseif line_number == 34 then
                shape_["color"] = row
            end
            line_number = line_number + 1
            word_number = 1
        end
    else
        print("error", err)
    end
    file:close()
    current_block = {shape_, gen}
    shape_choosed = true
    draw_board()

    states.inStartMenu = false
    states.inPause = false
    states.inGame = true
end

function choose_shape()
    return love.math.random(1, 7)
end

function call_shape()
    gen = choose_shape()
    return {shapes[gen][1], gen}
end

function move_wholeRow_down(rowNumber) 
    while(rowNumber > 0) do
        for j=1, maxWidth do
            board[rowNumber+1][j] = board[rowNumber][j] 
            board[rowNumber][j] = 0
        end
        rowNumber = rowNumber - 1
    end
end

function check_is_full(rowNumber)
    for i=2, maxWidth-1 do
        if board[rowNumber][i] == 0 then
            return false
        end
    end
    return true
end

function erase_full_rows()
    local num_of_rows = 0
    local full = true
    for i=1, maxHeight-1 do 
        if num_of_rows == 4 then
            break
        end
        if check_is_full(i) == true then
            move_wholeRow_down(i-1)
            love.graphics.setCanvas(scenes.game)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 155, 6, 100, 15)
            love.graphics.setCanvas()
            num_of_rows = num_of_rows + 1
        end
    end

    if num_of_rows == 1 then
        points = points + 5
    elseif num_of_rows == 2 then
        points = points + 15
    elseif num_of_rows == 3 then
        points = points + 40
    elseif num_of_rows == 4 then
        points = points + 75
    end

    draw_board()
    print("Actual points: "..points)
end

function end_of_game()
    for j=2, maxWidth-1 do
        if board[1][j] ~= 0 then
            print("Game Over!")
            print("Your points: "..points)
            love.event.quit(0)
        end
    end
end

function gameMechanism(dt_)
    if love.keyboard.isDown("p") then
        states.inGame = false
        states.inPause = true
    end

    if shape_choosed == false then
        end_of_game()
        erase_full_rows()
        current_block = call_shape()
        shape_choosed = true
    end

    if stopTime < 0 then
        if check_move_down(startXpos, startYpos, current_block[1]) == true then
            erase_shape(startXpos, startYpos, current_block[1])
            startXpos = startXpos + 1 
        else
            sounds.blip:play()
            save_block(startXpos, startYpos, current_block[1], current_block[2])
            shape_choosed = false
            current_block = nil
            startXpos = 1
            startYpos = 9
            draw_board()
        end
        stopTime = 0.5
    end
    if stopTime1 < 0 and current_block ~= nil then
        if love.keyboard.isDown("left") then
            if check_left_side(startXpos, startYpos, current_block[1]) == true then
                erase_shape(startXpos, startYpos, current_block[1])
                startYpos = startYpos - 1 
                stopTime1 = 0.1
            end
        end
        if love.keyboard.isDown("right") then
            if check_right_side(startXpos, startYpos, current_block[1]) == true then
                erase_shape(startXpos, startYpos, current_block[1])
                startYpos = startYpos + 1 
                stopTime1 = 0.1
            end
        end
    end
    if rollTime < 0 and current_block ~= nil then
        if love.keyboard.isDown("r") then
            g = current_block[2]
            possibilities = shapes[g]
            if rolltype > table.getn(possibilities) then
                rolltype = 1
            end
            erase_shape(startXpos, startYpos, current_block[1])
            current_block = {possibilities[rolltype], g}
            rolltype = rolltype + 1
            rollTime = 0.25
        end
    end

    stopTime = stopTime - dt_
    stopTime1 = stopTime1 - dt_
    rollTime = rollTime - dt_

end

function love.update(dt)
    if states.inGame == true then
        gameMechanism(dt)
    elseif states.inStartMenu == true then

    elseif states.inPause == true then
    
    elseif states.inEndGame == true then
    
    end
end

function love.draw() 
    if states.inGame == true then
        draw_info()
        love.graphics.draw(scenes.game)
        if current_block ~= nil then
            draw_shape(startXpos, startYpos, current_block[1], current_block[1].color)
        end
    elseif states.inStartMenu == true then
        draw_menu(buttons, scenes.startMenu)
        love.graphics.draw(scenes.startMenu)
    elseif states.inPause == true then
        draw_menu(pauseButtons, scenes.pause)
        love.graphics.draw(scenes.pause)
    elseif states.inEndGame == true then
        print("inEndGame")
    end
end