// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.12;

interface VowLike {
    function fess(uint256) external;
}

interface Kicker {
    function kick(address urn, address gal, uint256 tab, uint256 lot, uint256 bid)
        external returns (uint256);
}



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

interface SpotLike {
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

interface DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) external view returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;
    address      public  owner;

    constructor() public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    function setOwner(address owner_)
        public
        auth
    {
        owner = owner_;
        emit LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority_)
        public
        auth
    {
        authority = authority_;
        emit LogSetAuthority(address(authority));
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}


contract DSNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  guy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
        uint256           wad,
        bytes             fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;
        uint256 wad;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
            wad := callvalue()
        }

        _;

        emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
    }
}

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    //rounds to zero if x*y < WAD / 2
    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    //rounds to zero if x*y < WAD / 2
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    //rounds to zero if x*y < WAD / 2
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    //rounds to zero if x*y < RAY / 2
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

contract DSThing is DSAuth, DSNote, DSMath {
    function S(string memory s) internal pure returns (bytes4) {
        return bytes4(keccak256(abi.encodePacked(s)));
    }

}

contract DSValue is DSThing {
    bool    has;
    bytes32 val;
    function peek() public view returns (bytes32, bool) {
        return (val,has);
    }
    function read() public view returns (bytes32) {
        bytes32 wut; bool haz;
        (wut, haz) = peek();
        require(haz, "haz-not");
        return wut;
    }
    function poke(bytes32 wut) public note auth {
        val = wut;
        has = true;
    }
    function void() public note auth {  // unset the value
        has = false;
    }
}

contract RwaLiquidationOracle {
    // --- auth ---
    mapping (address => uint256) public wards;
    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }
    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }
    modifier auth {
        require(wards[msg.sender] == 1, "RwaOracle/not-authorized");
        _;
    }

    // --- math ---
    uint256 constant RAY = 10 ** 27;
    uint256 constant WAD = 10 ** 18;
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    
    //rounds to zero if x*y < WAD / 2
    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = uint256((x*100)/ y);
    }

    VatAbstract public vat;                 // MCD vat
    VowLike     public vow;                 // MCD vow
    SpotLike    public spotter;             // MCD spotter
    uint256     public adjustedValue;       // collateral value adjusted by liq ratio

    struct Ilk {
        string  doc;    // hash of borrower's agreement with MakerDAO
        address pip;    // DSValue tracking nominal loan value
        uint48  tau;    // pre-agreed remediation period
        uint48  toc;    // timestamp when liquidation initiated
        uint256 chop;   // liquidation penalty
        address flip;   // liquidation contract
        uint256 mat;    // liquidation ratio
    }

    // map of collaterals
    mapping (bytes32 => Ilk) public ilks;

    // Events
    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event File(bytes32 indexed what, address data);
    event File(bytes32 indexed what, uint256 data);
    event Init(bytes32 indexed ilk, uint256 val, string doc, uint48 tau);
    event Bump(bytes32 indexed ilk, uint256 val);
    event Dip(bytes32 indexed ilk, uint256 val);
    event Tell(bytes32 indexed ilk);
    event Cure(bytes32 indexed ilk);
    event Cull(bytes32 indexed ilk, address indexed urn);
    event Bite(
      bytes32 indexed ilk,
      address indexed urn,
      uint256 ink,
      uint256 art,
      uint256 tab,
      address flip,
      uint256 id
    );

    constructor(address vat_, address vow_, address spotter_) public {
        vat = VatAbstract(vat_);
        vow = VowLike(vow_);
        spotter = SpotLike(spotter_);
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
        emit File("vow", vow_);
    }

    // --- administration ---
    function file(bytes32 what, address data) external auth {
        if (what == "vow") { vow = VowLike(data); }
        else revert("RwaOracle/unrecognised-param");
        emit File(what, data);
    }

    function file(bytes32 ilk, bytes32 what, uint256 data) external auth {
        if (what == "mat") { ilks[ilk].mat = data; }
        else revert("RwaOracle/unrecognised-param");
        emit File(what, data);
    }

    // set auction contract & hope it
    function file(bytes32 ilk, bytes32 what, address flip) external auth {
        if (what == "flip") {
            vat.nope(ilks[ilk].flip);
            ilks[ilk].flip = flip;
            vat.hope(flip);
        }
        else revert("Cat/file-unrecognized-param");
    }

    function init(bytes32 ilk, uint256 val, string calldata doc, uint48 tau, uint256 mat_, uint256 chop) external auth {
        // doc, and tau can be amended, but tau cannot decrease
        require(tau >= ilks[ilk].tau, "RwaOracle/decreasing-tau");
        ilks[ilk].mat = mat_;
        ilks[ilk].doc = doc;
        ilks[ilk].tau = tau;
        ilks[ilk].chop = chop;

        //create new pip with val if not exist
        if (ilks[ilk].pip == address(0)) {
            DSValue pip = new DSValue();
            ilks[ilk].pip = address(pip);
            pip.poke(bytes32(val));
        } else {
            val = uint256(DSValue(ilks[ilk].pip).read());
        }

        // set adjusted value
        adjustedValue = div(val,ilks[ilk].mat);

        spotter.file(ilk,0x7069700000000000000000000000000000000000000000000000000000000000,ilks[ilk].pip);
        // spotter.poke(ilk);
        
        emit Init(ilk, val, doc, tau);
    }

    // --- valuation adjustment ---
    function bump(bytes32 ilk, uint256 val) external auth {
        DSValue pip = DSValue(ilks[ilk].pip);
        require(address(pip) != address(0), "RwaOracle/unknown-ilk");
        require(ilks[ilk].toc == 0, "RwaOracle/in-remediation");
        // only dip can decrease
        // require(val >= uint256(pip.read()), "RwaOracle/decreasing-val");
        pip.poke(bytes32(val));
        //update currRatio
        // (uint256 art,,,,) = vat.ilks(ilk);
        // currRatio = div(val,art);

        adjustedValue = div(val,ilks[ilk].mat);

        // bytes32 spotString = 0x73706f7400000000000000000000000000000000000000000000000000000000;

        // vat.file(ilk,spotString,mul(1000000000,val));
        spotter.poke(ilk);

        emit Bump(ilk, val);
    }

    // --- liquidation ---
    function liquidate(bytes32 ilk, address urn) external auth returns(uint256 id){
        // check vault is unsafe
        require(!this.good(ilk), "RwaOracle/not-unsafe");
        // get rate
        (,uint256 rate,,,) = vat.ilks(ilk);
        // get collateral balance & normalised debt
        (uint256 dink, uint256 dart) = vat.urns(ilk, urn);
        // confiscate vault
        vat.grab(
            ilk, urn, address(this), address(vow), -int256(dink), -int256(dart)
        );
        // write bad debt to vow
        vow.fess(mul(rate,dart));

        { // Avoid stack too deep
            // This calcuation will overflow if dart*rate exceeds ~10^14,
            // i.e. the maximum dunk is roughly 100 trillion DAI.
            // get debt to be covered, (outstanding debt + fees + liq penalty)
            uint256 tab = mul(mul(dart, rate), ilks[ilk].chop) / WAD;
            // start auction
            id = Kicker(ilks[ilk].flip).kick({
                urn: urn,
                gal: address(vow),
                tab: tab,
                lot: dink,
                bid: 0
            });
        }

        emit Bite(ilk, urn, dink, dart, mul(dart, rate), ilks[ilk].flip, id);
    }


    // --- liquidation check ---
    // to be called by off-chain parties (e.g. a trustee) to check the standing of the loan
    function good(bytes32 ilk) external view returns (bool) {
        require(ilks[ilk].pip != address(0), "RwaOracle/unknown-ilk");
        // get outstanding debt & adjusted value
        (uint256 Art,uint256 rate,uint256 spot,,) = vat.ilks(ilk);
        uint256 outstandingDebt = (mul(Art, rate));
        // good if outstanding debt < limit   
        if(mul(spot,WAD) > outstandingDebt){
            return true;
        }
        else{
            return false;
        }
    }
}