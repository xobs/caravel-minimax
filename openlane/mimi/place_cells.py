def make_6kb():
    bottom_margin = 130
    top_margin = 130
    left_margin = 130
    right_margin = 130

    # Note: we rotate the cells, so width and height are transposed
    cell_height = 431.86
    cell_width = 484.88
    vertical_cell_count = 3

    area_width = 3000
    area_height = 2000

    vertical_spacing = (
        (area_height - (bottom_margin + top_margin)) - (vertical_cell_count * cell_height)
    ) / (vertical_cell_count - 1)
    horizontal_spacing = [130, 704, 1810, 2385]

    for ram in range(0, 4):
        for bank in range(0, 3):
            print(
                f"bank{bank + 1}.ram{ram + 1} {horizontal_spacing[ram]} {int(bottom_margin + bank * vertical_spacing + bank * cell_height)} E"
            )
        print("")

    print("minimax.regfile_execution 1260 495 W")
    print("minimax.regfile_microcode 1575 495 E")

def make_8kb():
    bottom_margin = 60
    top_margin = 60

    # Note: we rotate the cells, so width and height are transposed
    cell_height = 431.86
    cell_width = 484.88
    vertical_cell_count = 4

    area_width = 3000
    area_height = 2000

    vertical_spacing = (
        (area_height - (bottom_margin + top_margin)) - (vertical_cell_count * cell_height)
    ) / (vertical_cell_count - 1)
    horizontal_spacing = [130, 704, 1810, 2385]

    for bank in range(0, 4):
        for ram in range(0, 4):
            print(
                f"bank{bank + 1}.ram{ram + 1} {horizontal_spacing[bank]} {int(bottom_margin + ram * vertical_spacing + ram * cell_height)} E"
            )
        print("")
    # bank1.ram1 50 70 E
    # bank1.ram2 50 540 E
    # bank1.ram3 50 1010 E
    # bank1.ram4 50 1480 W

    print("minimax.regfile_execution 1250 650 E")
    print("minimax.regfile_microcode 1530 650 W")

make_8kb()
