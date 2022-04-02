// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.12;


interface ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

// https://github.com/makerdao/dss/blob/master/src/spot.sol
interface SpotAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) external view returns (address, uint256);
    function vat() external view returns (address);
    function par() external view returns (uint256);
    function live() external view returns (uint256);
    function file(bytes32, bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function poke(bytes32) external;
    function cage() external;
}

// https://github.com/makerdao/dss/blob/master/src/vat.sol
interface VatAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function can(address, address) external view returns (uint256);
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
    function urns(bytes32, address) external view returns (uint256, uint256);
    function gem(bytes32, address) external view returns (uint256);
    function dai(address) external view returns (uint256);
    function sin(address) external view returns (uint256);
    function debt() external view returns (uint256);
    function vice() external view returns (uint256);
    function Line() external view returns (uint256);
    function live() external view returns (uint256);
    function init(bytes32) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function cage() external;
    function slip(bytes32, address, int256) external;
    function flux(bytes32, address, address, uint256) external;
    function move(address, address, uint256) external;
    function frob(bytes32, address, address, address, int256, int256) external;
    function fork(bytes32, address, address, int256, int256) external;
    function grab(bytes32, address, address, address, int256, int256) external;
    function heal(uint256) external;
    function suck(address, address, uint256) external;
    function fold(bytes32, address, int256) external;
}

// https://github.com/makerdao/dss/blob/master/src/jug.sol
interface JugAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) external view returns (uint256, uint256);
    function vat() external view returns (address);
    function vow() external view returns (address);
    function base() external view returns (address);
    function init(bytes32) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function drip(bytes32) external returns (uint256);
}

// https://github.com/dapphub/ds-token/blob/master/src/token.sol
interface DSTokenAbstract {
    function name() external view returns (bytes32);
    function symbol() external view returns (bytes32);
    function decimals() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function allowance(address, address) external view returns (uint256);
    function approve(address, uint256) external returns (bool);
    function approve(address) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function push(address, uint256) external;
    function pull(address, uint256) external;
    function move(address, address, uint256) external;
    function mint(uint256) external;
    function mint(address,uint) external;
    function burn(uint256) external;
    function burn(address,uint) external;
    function setName(bytes32) external;
    function authority() external view returns (address);
    function owner() external view returns (address);
    function setOwner(address) external;
    function setAuthority(address) external;
}

// https://github.com/makerdao/dss/blob/master/src/join.sol
interface GemJoinAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function vat() external view returns (address);
    function ilk() external view returns (bytes32);
    function gem() external view returns (address);
    function dec() external view returns (uint256);
    function live() external view returns (uint256);
    function cage() external;
    function join(address, bytes32, uint256) external;
    function exit(address, bytes32, uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/join.sol
interface DaiJoinAbstract {
    function wards(address) external view returns (uint256);
    function rely(address usr) external;
    function deny(address usr) external;
    function vat() external view returns (address);
    function dai() external view returns (address);
    function live() external view returns (uint256);
    function cage() external;
    function join(address, uint256) external;
    function exit(address, uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/dai.sol
interface DaiAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function version() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function allowance(address, address) external view returns (uint256);
    function nonces(address) external view returns (uint256);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external view returns (bytes32);
    function transfer(address, uint256) external;
    function transferFrom(address, address, uint256) external returns (bool);
    function mint(address, uint256) external;
    function burn(address, uint256) external;
    function approve(address, uint256) external returns (bool);
    function push(address, uint256) external;
    function pull(address, uint256) external;
    function move(address, address, uint256) external;
    function permit(address, address, uint256, uint256, bool, uint8, bytes32, bytes32) external;
}

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}

contract RwaUrn is ERC721TokenReceiver{
    // --- auth ---
    mapping (address => uint256) public wards;
    mapping (address => uint256) public can;
    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }
    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }
    modifier auth {
        require(wards[msg.sender] == 1, "RwaUrn/not-authorized");
        _;
    }
    function hope(address usr) external auth {
        can[usr] = 1;
        emit Hope(usr);
    }
    function nope(address usr) external auth {
        can[usr] = 0;
        emit Nope(usr);
    }
    modifier operator {
        require(can[msg.sender] == 1, "RwaUrn/not-operator");
        _;
    }

    VatAbstract  public vat;            // MCD vat
    JugAbstract  public jug;            // MCD jug
    GemJoinAbstract public gemJoin;     // NFT adapter
    DaiJoinAbstract public daiJoin;     // DAI adapter
    address public recipient;           // address to recieve DAI
    uint256 public tokenId;             // NFT token identifier
    bytes32 public ilk;                 // collateral name

    // Events
    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event Hope(address indexed usr);
    event Nope(address indexed usr);
    event File(bytes32 indexed what, address data);
    event Lock(address indexed usr, uint256 wad);
    event Free(address indexed usr, uint256 wad);
    event Draw(address indexed usr, uint256 wad);
    event Wipe(address indexed usr, uint256 wad);
    event Quit(address indexed usr, uint256 wad);

    // --- math ---
    uint256 constant RAY = 10 ** 27;
    uint256 constant WAD = 10 ** 18;
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    function divup(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(x, sub(y, 1)) / y;
    }

    // --- init ---
    constructor(
        address vat_, address jug_, address gemJoin_, address daiJoin_, address recipient_, uint256 tokenId_, bytes32 ilk_
    ) public {
        // requires in urn that outputConduit isn't address(0)
        require(recipient_ != address(0),"RwaUrn/invalid-recipient");
        //set contract addresses
        vat = VatAbstract(vat_);
        jug = JugAbstract(jug_);
        gemJoin = GemJoinAbstract(gemJoin_);
        daiJoin = DaiJoinAbstract(daiJoin_);
        recipient = recipient_;
        //approve creator
        wards[msg.sender] = 1;
        //has to be one less to fit in uint256
        uint256 maxVal = sub((2**255),1);
        //approve daiJoin
        DaiAbstract(daiJoin.dai()).approve(address(daiJoin), maxVal);
        VatAbstract(vat_).hope(address(daiJoin));
        //approve nft transfer
        ERC721(gemJoin.gem()).approve(address(this), tokenId);

        //set tokenID i.e. identify nft associated with this vault
        tokenId = tokenId_;
        ilk = ilk_;

        emit Rely(msg.sender);
        emit File("outputConduit", recipient_);
        emit File("jug", jug_);
    }

    // --- administration ---
    function file(bytes32 what, address data) external auth {
        if (what == "recipient") { recipient = data; }
        else if (what == "jug") { jug = JugAbstract(data); }
        else revert("RwaUrn/unrecognised-param");
        emit File(what, data);
    }

    // --- cdp operation ---
    // n.b. that the operator must bring the gem
    function lock() external operator {
        //send nft to thisUrn
        ERC721(gemJoin.gem()).safeTransferFrom(msg.sender, address(this), tokenId);
        //approve NftAdapter
        ERC721(gemJoin.gem()).approve(address(gemJoin), tokenId);
        //send nft to nftAdapter
        gemJoin.join(address(this), ilk, tokenId);
        //increase vault collateral balance by 1
        vat.frob(ilk, address(this), address(this), address(this), int(WAD), 0);
        emit Lock(msg.sender, WAD);
    }
    // n.b. that the operator takes the gem
    // and might not be the same operator who brought the gem
    function free() external operator {
        //decrease collateral balance by 1
        vat.frob(ilk, address(this), address(this), address(this), -int(WAD), 0);
        //send nft to operator
        gemJoin.exit(msg.sender, ilk, tokenId);
        emit Free(msg.sender, WAD);
    }
    // n.b. DAI can only go to the output conduit
    function draw(uint256 wad) external operator {
        require(recipient != address(0));
        //update fees
        jug.drip(ilk);
        //get normalised debt
        (,uint256 rate,,,) = vat.ilks(ilk);
        uint256 dart = divup(mul(RAY, wad), rate);
        require(dart <= 2**255 - 1, "RwaUrn/overflow");
        //increase vault debt by normalised newDebt
        vat.frob(ilk, address(this), address(this), address(this), 0, int(dart));
        //send ERC20 DAI to recipient
        daiJoin.exit(recipient, wad);
        emit Draw(msg.sender, wad);
    }
    // n.b. anyone can wipe
    function wipe(uint256 wad) external {
        //send ERC20 DAI from sender to vault
        daiJoin.join(address(this), wad);
        //update fees
        jug.drip(ilk);
        //get normalised amount
        (,uint256 rate,,,) = vat.ilks(ilk);
        uint256 dart = mul(RAY, wad) / rate;
        require(dart <= 2 ** 255, "RwaUrn/overflow");
        //decrease vault debt by normalised amount
        vat.frob(ilk, address(this), address(this), address(this), 0, -int(dart));
        emit Wipe(msg.sender, wad);
    }

    //wipe total debt balance
    function wipeAll() external {
        //update fees
        jug.drip(ilk);
        //get outstanding vault debt
        (uint256 Art,uint256 rate,,,) = vat.ilks(ilk);
        uint256 totalDebt = mul(Art,rate)/RAY;
        //turn ERC20 DAI into internal DAI from sender
        daiJoin.join(msg.sender,totalDebt);
        //decrease debt by normalised amount (to zero)
        vat.frob(ilk, address(this), address(this), msg.sender, 0, -int(Art));
    }

    // If Dai is sitting here after ES that should be sent back
    function quit() external {
        require(recipient != address(0));
        require(vat.live() == 0, "RwaUrn/vat-still-live");
        DSTokenAbstract dai = DSTokenAbstract(daiJoin.dai());
        uint256 wad = dai.balanceOf(address(this));
        dai.transfer(recipient, wad);
        emit Quit(msg.sender, wad);
    }

    //function to allow smart contract to recieve ERC721
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    )
      external
        override
        returns(bytes4)
    {
        _operator;
        _from;
        _tokenId;
        _data;
        // emit Received();
        return 0x150b7a02;
    }
}