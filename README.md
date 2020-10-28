# Ing2ynab

Convert ING CSV-files to YNAB-compatible import files

## Installation

mix deps.get
mix deps.compile
mix compile
mix run
mix escript.build
./ing2ynab -f <path_to_csv>
cat ynab.csv
