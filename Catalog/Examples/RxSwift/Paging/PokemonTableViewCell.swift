//
//  PokemonTableViewCell.swift
//  Catalog
//
//  Created by Filip Gulan on 13/09/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

struct PokemonTableCellItem: TableCellItem {
    let pokemon: Pokemon

    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: PokemonTableViewCell.self, for: indexPath)
        cell.textLabel?.text = pokemon.name
        return cell
    }

    var height: CGFloat {
        return 44
    }
    
}

class PokemonTableViewCell: UITableViewCell {

}
