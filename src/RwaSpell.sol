pragma solidity 0.5.12;

import "dss-interfaces/dss/VatAbstract.sol";
import "dss-interfaces/dapp/DSPauseAbstract.sol";
import "dss-interfaces/dss/JugAbstract.sol";
import "dss-interfaces/dss/SpotAbstract.sol";
import "dss-interfaces/dss/GemJoinAbstract.sol";
import "dss-interfaces/dapp/DSTokenAbstract.sol";
import "dss-interfaces/dss/ChainlogAbstract.sol";

interface RwaLiquidationLike {
    function wards(address) external returns (uint256);
    function ilks(bytes32) external returns (string memory,address,uint48,uint48);
    function rely(address) external;
    function deny(address) external;
    function init(bytes32, uint256, string calldata, uint48) external;
    function tell(bytes32) external;
    function cure(bytes32) external;
    function cull(bytes32) external;
    function good(bytes32) external view;
}

interface RwaOutputConduitLike {
    function wards(address) external returns (uint256);
    function can(address) external returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function hope(address) external;
    function nope(address) external;
    function bud(address) external returns (uint256);
    function kiss(address) external;
    function diss(address) external;
    function pick(address) external;
    function push() external;
}

interface RwaUrnLike {
    function hope(address) external;
}

contract SpellAction {
    // KOVAN ADDRESSES
    //
    // The contracts in this list should correspond to MCD core contracts, verify
    // against the current release list at:
    //     https://changelog.makerdao.com/releases/kovan/latest/contracts.json
    ChainlogAbstract constant CHANGELOG =
        ChainlogAbstract(0x7368c1a7E459ab0b53A54867B289F45ceE519550);

    /*
        OPERATOR: 0xD23beB204328D7337e3d2Fb9F150501fDC633B0e
        TRUST1: 0xda0fab060e6cc7b1C0AA105d29Bd50D71f036711
        TRUST2: 0xDA0111100cb6080b43926253AB88bE719C60Be13
        ILK: RWA001-A
        RWA001: 0x8F9A8cbBdfb93b72d646c8DEd6B4Fe4D86B315cB
        MCD_JOIN_RWA001_A: 0x029A554f252373e146f76Fa1a7455f73aBF4d38e
        RWA001_A_URN: 0x3Ba90D86f7E3218C48b7E0FCa959EcF43d9A30F4
        RWA001_A_INPUT_CONDUIT: 0xe37673730F03060922a2Bd8eC5987AfE3eA16a05
        RWA001_A_OUTPUT_CONDUIT: 0xc54fEee07421EAB8000AC8c921c0De9DbfbE780B
        MIP21_LIQUIDATION_ORACLE: 0x2881c5dF65A8D81e38f7636122aFb456514804CC
    */
    address constant RWA999_OPERATOR           = 0x8519cd7e0CF6E757a1Df45c906d640DcEfb2869e;
    address constant RWA999_GEM                = 0xCf6d93E8Da96654771f76f90165B39Ae6647611A;
    address constant MCD_JOIN_RWA999_A         = 0x6605Bf7168223574A5F9AbcaaBf718cF6c674705;
    
    address constant RWA999_A_URN              = 0xc9f6b85b362a338BE0De500AD262f0203942e7eE;
    address constant RWA999_A_INPUT_CONDUIT    = 0x917D49182D46D88f6EC39D2d542d491629A32c5E; //to do
    address constant RWA999_A_OUTPUT_CONDUIT   = 0xe024543da5D4876C234fc70eC4fc6Bc936C43831;
    address constant MIP21_LIQUIDATION_ORACLE  = 0x2881c5dF65A8D81e38f7636122aFb456514804CC; //to do

    uint256 constant THREE_PCT_RATE  = 1000000000937303470807876289;

    // precision
    uint256 constant public THOUSAND = 10 ** 3;
    uint256 constant public MILLION  = 10 ** 6;
    uint256 constant public WAD      = 10 ** 18;
    uint256 constant public RAY      = 10 ** 27;
    uint256 constant public RAD      = 10 ** 45;

    uint256 constant RWA999_A_INITIAL_DC    = 1000 * RAD;
    uint256 constant RWA999_A_INITIAL_PRICE = 1060 * WAD;

    // MIP13c3-SP4 Declaration of Intent & Commercial Points -
    //   Off-Chain Asset Backed Lender to onboard Real World Assets
    //   as Collateral for a DAI loan
    //
    // https://ipfs.io/ipfs/QmdmAUTU3sd9VkdfTZNQM6krc9jsKgF2pz7W1qvvfJo1xk
    string constant DOC = "Testing Purposes"; //change this?

    function execute() external {
        address MCD_VAT  = ChainlogAbstract(CHANGELOG).getAddress("MCD_VAT");
        address MCD_JUG  = ChainlogAbstract(CHANGELOG).getAddress("MCD_JUG");
        address MCD_SPOT = ChainlogAbstract(CHANGELOG).getAddress("MCD_SPOT");

        // RWA999-A collateral deploy

        // Set ilk bytes32 variable
        bytes32 ilk = "RWA999-A";

        // add RWA-999 contract to the changelog
        CHANGELOG.setAddress("RWA999", RWA999_GEM);
        CHANGELOG.setAddress("MCD_JOIN_RWA999_A", MCD_JOIN_RWA999_A);
        CHANGELOG.setAddress("MIP21_LIQUIDATION_ORACLE", MIP21_LIQUIDATION_ORACLE);
        CHANGELOG.setAddress("RWA999_A_URN", RWA999_A_URN);
        CHANGELOG.setAddress("RWA999_A_INPUT_CONDUIT", RWA999_A_INPUT_CONDUIT);
        CHANGELOG.setAddress("RWA999_A_OUTPUT_CONDUIT", RWA999_A_OUTPUT_CONDUIT);

        // bump changelog version
        // TODO make sure to update this version on mainnet
        // CHANGELOG.setVersion("1.2.9");

        // Sanity checks
        require(GemJoinAbstract(MCD_JOIN_RWA999_A).vat() == MCD_VAT, "join-vat-not-match");
        require(GemJoinAbstract(MCD_JOIN_RWA999_A).ilk() == ilk, "join-ilk-not-match");
        require(GemJoinAbstract(MCD_JOIN_RWA999_A).gem() == RWA999_GEM, "join-gem-not-match");
        require(GemJoinAbstract(MCD_JOIN_RWA999_A).dec() == DSTokenAbstract(RWA999_GEM).decimals(), "join-dec-not-match");

        // init the RwaLiquidationOracle
        // doc: "doc"
        // tau: 5 minutes
        RwaLiquidationLike(MIP21_LIQUIDATION_ORACLE).init(
            ilk, RWA999_A_INITIAL_PRICE, DOC, 300
        );
        (,address pip,,) = RwaLiquidationLike(MIP21_LIQUIDATION_ORACLE).ilks(ilk);
        CHANGELOG.setAddress("PIP_RWA999", pip);

        // Set price feed for RWA999
        SpotAbstract(MCD_SPOT).file(ilk, "pip", pip);

        // Init RWA-999 in Vat
        VatAbstract(MCD_VAT).init(ilk);
        // Init RWA-999 in Jug
        JugAbstract(MCD_JUG).init(ilk);

        // Allow RWA-999 Join to modify Vat registry
        VatAbstract(MCD_VAT).rely(MCD_JOIN_RWA999_A);

        // Allow RwaLiquidationOracle to modify Vat registry
        VatAbstract(MCD_VAT).rely(MIP21_LIQUIDATION_ORACLE);

        // 1000 debt ceiling
        VatAbstract(MCD_VAT).file(ilk, "line", RWA999_A_INITIAL_DC);
        VatAbstract(MCD_VAT).file("Line", VatAbstract(MCD_VAT).Line() + RWA999_A_INITIAL_DC);

        // No dust
        // VatAbstract(MCD_VAT).file(ilk, "dust", 0)

        // 3% stability fee
        JugAbstract(MCD_JUG).file(ilk, "duty", THREE_PCT_RATE);

        // collateralization ratio 100%
        SpotAbstract(MCD_SPOT).file(ilk, "mat", RAY);

        // poke the spotter to pull in a price
        SpotAbstract(MCD_SPOT).poke(ilk);

        // give the urn permissions on the join adapter
        GemJoinAbstract(MCD_JOIN_RWA999_A).rely(RWA999_A_URN);

        // set up the urn
        RwaUrnLike(RWA999_A_URN).hope(RWA999_OPERATOR);

        // set up output conduit
        RwaOutputConduitLike(RWA999_A_OUTPUT_CONDUIT).hope(RWA999_OPERATOR);
        // could potentially kiss some BD addresses if they are available
    }
}

contract RwaSpell {

    ChainlogAbstract constant CHANGELOG =
        ChainlogAbstract(0x7368c1a7E459ab0b53A54867B289F45ceE519550);

    DSPauseAbstract public pause =
        DSPauseAbstract(CHANGELOG.getAddress("MCD_PAUSE"));
    address         public action;
    bytes32         public tag;
    uint256         public eta;
    bytes           public sig;
    uint256         public expiration;
    bool            public done;

    string constant public description = "Test Goerli Spell Deploy";

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
        expiration = block.timestamp + 30 days;
    }

    function schedule() public {
        require(block.timestamp <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = block.timestamp + DSPauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}
