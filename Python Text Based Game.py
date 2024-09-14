#  Text Based Python Game by Kellie Lord

#  Function for player instructions
def player_instructions():
    print('-------------------------------------------------')
    print('Princess Python and the Battle for Python Palace!')
    print('-------------------------------------------------')
    print('All is well in the Python Palace...')
    print('Until the evil Black Moon Syntax invades the Crystal Tower!')
    print('Hurry, help Princess Python collect all the components of her Software Scepter!')
    print('Or Black Moon Syntax will take over the entire kingdom...')
    print("And don't forget her puppy sidekick, Byte! Only he can assemble the Scepter!")
    print('--------------')
    print('To move, enter North, South, East, or West!')
    print('To add to inventory, enter Y/N!')
    print('To quit, type "exit"')


#  Display instructions to the player
player_instructions()


#  Main() statement
def main():
    #  Dictionary for the rooms and their corresponding items
    rooms = {
        'Terrace of Truth': {'South': 'Moonlit Garden', 'East': 'Palace Hall'},
        'Moonlit Garden': {'North': 'Terrace of Truth', 'item': 'sidekick Byte'},
        'Palace Hall': {'West': 'Terrace of Truth', 'North': 'Chamber of Prayer', 'South':
            'Throne Room', 'East': 'Boolean Ballroom', 'item': 'Scepter Handle'},
        'Chamber of Prayer': {'South': 'Palace Hall', 'East': 'Time Portal Room', 'item': 'Scepter Halo'},
        'Time Portal Room': {'West': 'Chamber of Prayer', 'item': 'Scepter Pearl'},
        'Throne Room': {'North': 'Palace Hall', 'East': 'Crystal Tower', 'item': 'Scepter Jewel'},
        'Crystal Tower': {'West': 'Throne Room', 'item': 'Black Moon Syntax'},
        'Boolean Ballroom': {'West': 'Palace Hall', 'North': 'War Scripting Room',
                             'item': 'Scepter Energy Heart'},
        'War Scripting Room': {'South': 'Boolean Ballroom', 'item': 'Scepter Ribbon'}

    }

    #  Starting room, variable current_room, and empty list for inventory
    start = 'Terrace of Truth'
    current_room = start
    inventory = []

    #  While loop for the bulk of gameplay
    while True:
        print('--------------')
        print('You are in the {}'.format(current_room))
        print('Inventory: {}'.format(inventory))
        move = input('Enter your move: ').capitalize()  # Move input, .capitalize to allow for both upper and lowercase

        if move == 'Exit':  # If the player inputs "Exit"
            print('--------------')
            print('Thanks for playing!')
            print('Goodbye!')
            print('--------------')
            break  # The game ends

        if move in rooms[current_room]:  # As long as the move entered matches up in the rooms dictionary
            current_room = rooms[current_room][move]  # New room is entered
        else:  # If any other input is entered
            print('--------------')
            print('Invalid move! Please try again.')  # Invalid move
            continue  # Instead of breaking this will prompt for new input

        if 'item' in rooms[current_room]:  # If loop for the losing scenario
            if rooms[current_room]['item'] == 'Black Moon Syntax' and len(inventory) != 7:  # If len inventory is not 7
                print('--------------')
                if 'sidekick Byte' in inventory:  # Kind of an Easter egg: if you have Byte, but lose
                    print('Byte: Yelp!')
                print("OH NO! It's Black Moon Syntax!")
                print('The Software Scepter is incomplete!')
                print('Princess Python was unable to defeat Black Moon Syntax...')
                print('****GAME OVER****')
                break  # The game is lost and will break

        if 'item' in rooms[current_room]:  # If loop for the winning scenario
            if rooms[current_room]['item'] == 'Black Moon Syntax' and len(inventory) == 7:  # If len inventory IS 7
                print('--------------')
                print('Byte uses his Love Loop telekinesis to assemble the Scepter...')
                print('Black Moon Syntax disintegrates from the Software Scepter energy beam...')
                print("You've done it!")
                print('Princess Python has saved Python Palace!')
                print('Peace has been restored!')
                print('Byte: Yip yip!')
                print('****YOU WIN****')
                print('--------------')
                break  # The game is won, and will break

        if ('item' in rooms[current_room]) and (rooms[current_room]['item'] not in inventory):  # If loop for items
            current_item = rooms[current_room]['item']  # Calling from the dictionary
            print('--------------')
            print('You enter the {}'.format(current_room))
            print("Look! you've found the {}!".format(current_item))
            if current_item == 'sidekick Byte':  # Special text for Byte
                print('Byte: Yip yip!')
            pickup = input('Pick up the {}? Y/N '.format(current_item)).capitalize()  # Input whether to pickup item
            if pickup == 'Y':
                inventory.append(current_item)  # Add the item to the end of the inventory list
            elif pickup == 'N':  # If n is entered
                print('--------------')
                print('Hmm... We might need that later...')
                continue
            else:  # If invalid is entered
                print('--------------')
                print('Invalid move!')
                continue


main()  # Display everything in main()
