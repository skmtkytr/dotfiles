local M = {
  days_of_week = {},
  dragon = {},
}

--- @class DragonLogo
local dragon = {
  night_fury = [[
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⠿⣋⣭⢍⣩⣝⢿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⣫⣶⣿⣟⣵⣿⣿⣿⣷⣝⢿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⡿⣣⣶⣶⣄⡲⣬⣍⡛⠿⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⢀⣴⢟⣵⣿⣿⣿⢏⣾⣿⡿⣫⣷⣿⣿⡮⡻⣿⣿⣷⣦⡀⠀⠀⠀⠀⣀⣤⣴⣶⣶⣦⡄⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠟⣴⣿⣿⣿⣿⣿⣎⠻⣿⣷⣦⣍⡛⠿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⣠⢟⣵⣿⣿⣿⣿⡏⣾⣿⢟⣾⣿⣿⣿⣿⣷⣿⣮⠻⣿⣿⣿⢦⡀⣠⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢀⣴⣿⣿⣿⢋⣾⣿⣿⣿⣿⣿⣿⣿⣷⡝⣿⣿⣿⣿⣷⣬⣙⠻⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⡼⣣⣿⣿⣿⣿⣿⣿⢸⣿⡟⣾⣿⣿⣿⣿⣿⣿⣫⣾⣧⣬⣽⣾⣷⣭⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⢀⣀⣴⣿⣿⣿⡿⣱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡌⢿⣿⣿⣿⣿⣿⣷⣮⣝⠷⣦⡀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⢀⡾⣱⣿⣿⣿⣿⣿⣿⡏⣿⣿⡷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣣⣶⣿⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡌⣿⣿⣿⣿⣿⣿⣿⣿⣷⣬⡻⣦⡀⠀⠀⠀⠀⠀
  ⠀⠀⠀⡼⣱⣿⠿⠿⠻⠿⣿⣿⡇⣿⣿⢧⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣵⣶⡎⣿⣿⠿⢟⣛⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡸⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣎⢻⡄⠀⠀⠀⠀
  ⠀⠀⠀⣇⠟⠁⠀⠀⠀⠀⠀⠙⢧⢿⣇⣿⡏⠀⢹⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢻⠀⠀⢨⣿⣿⣿⡿⣟⣙⣻⠿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣏⠉⠉⠉⠉⠉⠛⠛⢧⢹⠟⠉⠀⠀⠀⠀⠀⠈⠛⢿⡎⣧⠀⠀⠀⠀
  ⠀⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⠸⠃⣿⣷⣄⡈⠀⣻⣿⣿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣴⣿⣿⣿⡿⣴⣿⣿⣿⣿⣮⡹⣿⣿⣿⡝⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠙⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠽⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣞⢿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣬⣛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⢀⣼⣿⣿⣿⣿⣿⣿⢃⣿⣿⣿⣿⣿⡎⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣶⣯⣽⡟⠛⠛⠛⠛⠉⠁⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⠏⣼⣿⣿⣿⣿⣿⠃⠻⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⡏⣼⣿⣿⣿⣿⣿⠇⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⢸⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⣼⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⠉⠿⠿⠍⠻⠿⠍⠃⠀⠀⠃⠹⠿⠇⢨⠿⠻⠀⠛⠁⠀⠃⠘⠛⠈⠛⠛⠀⠁⠀⠀⠀⠀⢸⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣄⣀⣀⠀⠤⣤⠤⠤⠤⠤⠤⢤⣤⣤⣤⣤⣀⣀⣀⠀⠀⠀⠀⠀⢀⣠⣿⣿⣿⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡐⢚⣫⣭⢄⣶⣾⣿⢋⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠛⠛⠻⠿⠿⠿⣿⡿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡿⣵⣿⣿⡏⣾⠿⠛⠛⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠋⠉⠉⠁⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ]],
  western_dragon = [[
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢠⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣶⣿⠛⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠛⣿⣶⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣿⡿⣟⣽⡏⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⢹⣯⣻⢿⣿⣶⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⡿⢟⣫⣵⣾⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣮⣝⡻⢿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⡿⢛⣡⣶⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣶⣌⡛⢿⣿⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⡿⢋⣴⣿⣿⣿⡿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢍⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⢿⣿⣿⣿⣦⡙⢿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⡿⢋⣴⣿⣿⣿⡿⣫⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⢍⣿⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣷⣝⢿⣿⣿⣿⣦⡙⢿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⠟⡋⣿⠟⣡⣾⣿⣿⣿⣫⣾⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢿⢍⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣷⣝⣿⣿⣿⣷⣌⠻⣿⢙⠻⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡿⠟⢻⣿⡿⢋⣼⢣⢋⣴⣿⣿⣿⢟⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣠⣄⣀⡀⢀⣀⠀⣠⣴⠿⣏⣼⣯⣿⣧⣹⠿⣦⣄⠀⣀⡀⢀⣀⣠⣄⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⡻⣿⣿⣿⣦⡙⡞⣧⡙⢿⣿⡟⠻⢿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⣫⡴⣡⣿⡿⢡⣿⡟⣡⣾⣿⣿⣿⣫⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣽⣻⠿⣿⣿⣿⣿⣾⡿⠎⣸⡿⣿⣿⢛⣇⠹⢿⣿⣿⣿⣿⣿⠿⣟⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣝⣿⣿⣿⣷⣌⢻⣿⡌⢿⣿⣌⢦⣝⢿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⣴⡿⢋⣴⡿⣱⣿⡿⢡⣿⣿⣴⣿⣿⣿⡿⣱⣿⣿⣿⣿⣿⣿⠟⢿⣿⣿⣿⠻⢿⣿⣿⣿⣿⣾⣷⡹⣿⡎⣧⣿⣿⣽⣯⣿⣿⣼⡹⣿⢋⣾⣷⣿⣿⣿⣿⡿⠟⣿⣿⣿⡿⠻⣿⣿⣿⣿⣿⣿⣎⢿⣿⣿⣿⣦⣿⣿⡌⢿⣿⣎⢿⣦⡙⢿⣦⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⢀⣾⠟⢠⣿⣿⢱⣿⣿⢁⣾⡿⠿⢿⣿⣿⡟⠔⠉⠛⣿⣿⣿⠏⠀⠀⠀⢺⣿⠃⠀⠀⢻⣿⠛⠿⣿⣿⣿⣌⢹⣝⡮⡙⣻⣟⢋⢕⣫⡏⣡⣿⣿⣿⠿⠛⣿⡟⠀⠀⠘⣿⡗⠀⠀⠀⠹⣿⣿⣿⠛⠉⠢⢻⣿⣿⡿⠿⢟⣷⡈⣿⣿⡎⣿⣿⡄⠻⣷⡀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⣠⡿⠁⢀⣿⣿⢇⣿⣿⠇⠜⠁⠀⠀⣼⣿⡟⠀⠀⠀⠈⣿⡿⠃⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⢿⠀⠀⠙⣿⡟⠻⢠⢻⣿⡮⢻⡟⣵⣿⡟⡄⠟⢻⣿⠋⠀⠀⡿⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠘⢿⣿⠁⠀⠀⠀⢻⣿⣧⠀⠀⠈⠣⠸⣿⣿⡸⣿⣿⡀⠈⢿⣄⠀⠀⠀⠀
  ⠀⠀⠀⣰⠏⠀⢀⣾⣿⣿⢠⣿⡟⠀⠀⠀⠀⠀⣿⡟⠀⠀⠀⠀⠀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃ ⣿⣷⣭⣿⡩⡩⣳⣭⣾⣿ ⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⠀⠀⠀⠀⠀⢻⣿⠀⠀⠀⠀⠀⢻⣿⡄⣿⣿⣷⡀⠀⠹⣆⠀⠀⠀
  ⠀⠀⡰⠃⠀⠀⣼⣿⡿⠃⢸⣿⠃⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⡟⠿⣫⣿⣿⣿⣿⣿⣯⡟⠿⢻ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡇⠀⠀⠀⠀⠘⣿⡇⠘⢿⣿⣧⠀⠀⠘⢆⠀⠀
  ⠀⠔⠀⠀⠀⢰⣿⠟⠀⠀⢸⣿⠀⠀⠀⠀⠀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣯⡛⣿⡿⣫⣾⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⠀⠀⠀⠀⠀⣿⡇⠀⠀⠻⣿⡆⠀⠀⠀⠢⠀
  ⠀⠀⠀⠀⢀⣿⠉⠀⠀⠀⢸⣿⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⣿⡇⣿⡆⠻⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠀⠀⠀⠀⣿⡇⠀⠀⠀⠉⣿⡀⠀⠀⠀⠀
  ⠀⠀⠀⠀⣸⠏⠀⠀⠀⠀⠈⣿⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣞⠀⣿⡇⠰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠹⣇⠀⠀⠀⠀
  ⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠀⢿⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ]],
}

local days_of_week = {
  Monday = [[
███╗   ███╗ ██████╗ ███╗   ██╗██████╗  █████╗ ██╗   ██╗
████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝
██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝⠀
██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝⠀⠀
██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║⠀⠀⠀
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
  Tuesday = [[
████████╗██╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗
╚══██╔══╝██║   ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
   ██║   ██║   ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝⠀
   ██║   ██║   ██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝⠀⠀
   ██║   ╚██████╔╝███████╗███████║██████╔╝██║  ██║   ██║⠀⠀⠀
   ╚═╝    ╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
  Wednesday = [[
██╗    ██╗███████╗██████╗ ███╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗
██║    ██║██╔════╝██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
██║ █╗ ██║█████╗  ██║  ██║██╔██╗ ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝⠀
██║███╗██║██╔══╝  ██║  ██║██║╚██╗██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝⠀⠀
╚███╔███╔╝███████╗██████╔╝██║ ╚████║███████╗███████║██████╔╝██║  ██║   ██║⠀⠀⠀
 ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
  Thursday = [[
████████╗██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗ ██╗   ██╗
╚══██╔══╝██║  ██║██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
   ██║   ███████║██║   ██║██████╔╝███████╗██║  ██║███████║ ╚████╔╝⠀
   ██║   ██╔══██║██║   ██║██╔══██╗╚════██║██║  ██║██╔══██║  ╚██╔╝⠀⠀
   ██║   ██║  ██║╚██████╔╝██║  ██║███████║██████╔╝██║  ██║   ██║⠀⠀⠀
   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
  Friday = [[
███████╗██████╗ ██╗██████╗  █████╗ ██╗   ██╗
██╔════╝██╔══██╗██║██╔══██╗██╔══██╗╚██╗ ██╔╝
█████╗  ██████╔╝██║██║  ██║███████║ ╚████╔╝⠀
██╔══╝  ██╔══██╗██║██║  ██║██╔══██║  ╚██╔╝⠀⠀
██║     ██║  ██║██║██████╔╝██║  ██║   ██║⠀⠀⠀
╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
  Saturday = [[
███████╗ █████╗ ████████╗██╗   ██╗██████╗ ██████╗  █████╗ ██╗   ██╗
██╔════╝██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
███████╗███████║   ██║   ██║   ██║██████╔╝██║  ██║███████║ ╚████╔╝⠀
╚════██║██╔══██║   ██║   ██║   ██║██╔══██╗██║  ██║██╔══██║  ╚██╔╝⠀⠀
███████║██║  ██║   ██║   ╚██████╔╝██║  ██║██████╔╝██║  ██║   ██║⠀⠀⠀
╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
  Sunday = [[
███████╗██╗   ██╗███╗   ██╗██████╗  █████╗ ██╗   ██╗
██╔════╝██║   ██║████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝
███████╗██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝⠀
╚════██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝⠀⠀
███████║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║⠀⠀⠀
╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝⠀⠀⠀
  ]],
}

M.days_of_week.generate = function()
  local current_day = os.date("%A")
  return vim.split("\n\n\n" .. days_of_week[current_day] .. "\n\n" .. os.date("%Y-%m-%d %H:%M:%S" .. "\n"), "\n")
end

--- @param type "night_fury" | "western_dragon"
M.dragon.generate = function(type)
  return vim.split("\n" .. dragon[type], "\n")
end

M.dragon.random = function()
  math.randomseed(os.time())
  local logo_names = { "night_fury", "western_dragon" }
  local random_logo_name = logo_names[math.random(1, #logo_names)]
  return vim.split(dragon[random_logo_name], "\n")
end

return M
