//
//  GamePresenter.swift
//  Players_and_Monsters
//
//  Created by Анна Вертикова on 27.09.2023.
//

import Foundation
import UIKit


class GamePresenter: GamePresenterPropertiesProtocol {
    
    weak var viewController: GamePresenterToViewResponseProtocol?
    var interactor: GamePresenterToInteractorRequestProtocol?
    var router: GamePresenterToRouterRequestProtocol?
    
    
}

extension GamePresenter: GameViewToPresenterRequestProtocol {
    func attackButtonTapped(attackRequest: GetGameData.AttackRequest) {
        interactor?.attackButtonTapped(attackRequest: attackRequest)
    }
    
    func healButtonTapped() {
        interactor?.healButtonTapped()
    }
    
    func fetchGame(request: GetGameData.GameInitRequest) {
        interactor?.initGame(request: request)
    }
    
    
    
}

extension GamePresenter: GameInteractorToPresenterResponseProtocol {
    
    func fetchAttackResult(response: GetGameData.Response) {
        self.fetchAttackInfo(response: response)
        if response.gameService?.currentAttackResult?.attackSuccess == true {
            self.fetchAttackSuccess(response: response)
            if response.gameService?.currentAttackResult?.gameOver == true {
                self.fetchGameOver(response: response)
            }
        } else {
            self.fetchAttackFail()
        }
    }
    
    func fetchAttackInfo(response: GetGameData.Response) {
        var attackerName: String = ""
        var defenderName: String = ""
        var attackPower: UInt = 0
        var defensePower: UInt = 0
        var attackModifier: UInt = 0
        
        if let attacker = response.gameService?.currentAttackInfo?.attacker {
            attackerName = attacker
        }
        if let defender = response.gameService?.currentAttackInfo?.defender {
            defenderName = defender
        }
        if let attack = response.gameService?.currentAttackInfo?.attackPower {
            attackPower = attack
        }
        if let deffense = response.gameService?.currentAttackInfo?.defensePower {
            defensePower = deffense
        }
        if let modifier = response.gameService?.currentAttackInfo?.attackModifier {
            attackModifier = modifier
        }
        
        
        let dataToDisplay: String = """

    \(attackerName) атакует с силой \(attackPower)!
    \(defenderName) защищается с силой \(defensePower).
    Модификатор атаки: \(attackModifier).

"""
        viewController?.showView(dataToDisplay: dataToDisplay)
    }
    
    func fetchAttackSuccess(response: GetGameData.Response) {
        var dataToDisplay: String = ""
        var defenderName: String  = ""
        var damageGained: UInt = 0
        var currentHealth: UInt = 0
        
        if let defender = response.gameService?.currentAttackInfo?.defender {
            defenderName = defender
        }
        
        if let damage = response.gameService?.currentAttackResult?.damage {
            damageGained = damage
        }
        
        if let health = response.gameService?.currentAttackResult?.defenderHealth {
            currentHealth = health
        }
        if response.gameService?.currentAttackResult?.monsterHealed == true {
            dataToDisplay = """

    Успешная атака!
    \(defenderName) получает урон \(damageGained)
    и принимает исцеляющую микстуру.
    Здоровье \(defenderName): \(currentHealth).

"""
        } else {
            dataToDisplay = """

    Успешная атака!
    \(defenderName) получает урон \(damageGained).
    Здоровье \(defenderName): \(currentHealth).

"""
            }
        viewController?.showView(dataToDisplay: dataToDisplay)
        
    }
    
    
    func fetchAttackFail() {
        let dataToDisplay: String = """
    
    Атака провалена!

"""
        viewController?.showView(dataToDisplay: dataToDisplay)
    }
    
    
    func fetchPlayerHealSuccess(response: GetGameData.Response) {
        var playerHealPills: UInt = 0
        var playerCurrentHealth: UInt = 0
        
        
        if let health = response.gameService?.playerHealResult?.currentHealth {
            playerCurrentHealth = health
        } 
        
        if let healPills = response.gameService?.playerHealResult?.healPills {
            playerHealPills = healPills
        }
        
        let dataToDisplay: String = """

    М-м-м-микстура! Так-то лучше!
    Здоровье: \(playerCurrentHealth).
    Осталось микстур: \(playerHealPills).

"""
        viewController?.showView(dataToDisplay: dataToDisplay)
    }
    
    
    func fetchPlayerHealFail() {
        let dataToDisplay: String = "\n\nОй, у тебя нет исцеляющих микстур!\nНо ты держись там!\n\n"
        viewController?.showNoHealPillsView(dataToDisplay: dataToDisplay)
    }
    
    
    func fetchGameOver(response: GetGameData.Response) {
        if let winner = response.gameService?.currentAttackInfo?.attacker {
            let dataToDisplay: String = """

    ==========ИГРА ОКОНЧЕНА!===========
            Победил \(winner).
    ===================================
    

"""
            viewController?.showGameOver(dataToDisplay: dataToDisplay)
        }
    }
}
