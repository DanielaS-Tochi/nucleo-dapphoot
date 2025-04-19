// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title HootToken
 * @dev Token ERC-20 para el juego dAppHoot
 * Los tokens se otorgan a los jugadores por respuestas correctas
 */
contract HootToken is ERC20, ERC20Burnable, Ownable, AccessControl {
    // Rol para permitir el minteo de tokens
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE") ;
    
    // Eventos
    event TokensMinted(address indexed to, uint256 amount);
    
    /**
     * @dev Constructor que establece el nombre y símbolo del token
     * Mintea 1000 tokens iniciales para el deployer
     */
    constructor(address initialOwner) 
        ERC20("HootToken", "HOOT") 
        Ownable(initialOwner)
    {
        _grantRole(DEFAULT_ADMIN_ROLE, initialOwner);
        _grantRole(MINTER_ROLE, initialOwner);
        
        // Minteo inicial de 1000 tokens para el deployer
        _mint(initialOwner, 1000 * 10 ** decimals());
        emit TokensMinted(initialOwner, 1000 * 10 ** decimals());
    }
    
    /**
     * @dev Permite a las cuentas con rol MINTER_ROLE mintear nuevos tokens
     * @param to Dirección que recibirá los tokens
     * @param amount Cantidad de tokens a mintear
     */
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }
    
    /**
     * @dev Función para otorgar el rol de MINTER a una dirección
     * Solo puede ser llamada por el admin
     * @param minter Dirección que recibirá el rol de MINTER
     */
    function addMinter(address minter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }
    
    /**
     * @dev Función para revocar el rol de MINTER a una dirección
     * Solo puede ser llamada por el admin
     * @param minter Dirección a la que se le revocará el rol de MINTER
     */
    function removeMinter(address minter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(MINTER_ROLE, minter);
    }
    
    // Implementación requerida por Solidity para compatibilidad con AccessControl
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
