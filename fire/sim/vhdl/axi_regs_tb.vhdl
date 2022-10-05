library ieee, support, work;
  use ieee.std_logic_1164.all;
  use support.syn_util_functions_pkg.all;
  use work.axi_pkg.all;

entity axi_regs_tb is
  port (
    dummy : out std_ulogic
  );
end axi_regs_tb;

architecture axi_regs_tb of axi_regs_tb is
  signal s0_axi_i        : t_AXI4_LITE_SLAVE_INPUT;
  signal s0_axi_o        : t_AXI4_LITE_SLAVE_OUTPUT;
  signal s0_axi_aclk     : std_ulogic;
  signal s0_axi_aresetn  : std_ulogic                     := '1';
  signal s0_axi_awvalid  : std_ulogic                     := '0';
  signal s0_axi_awready  : std_ulogic;
  signal s0_axi_awaddr   : std_ulogic_vector(31 downto 0) := x"00000000";
  signal s0_axi_awprot   : std_ulogic_vector(2 downto 0)  := "000";
  signal s0_axi_wvalid   : std_ulogic                     := '0';
  signal s0_axi_wready   : std_ulogic;
  signal s0_axi_wdata    : std_ulogic_vector(31 downto 0) := x"00000000";
  signal s0_axi_wstrb    : std_ulogic_vector(3 downto 0)  := "0000";
  signal s0_axi_bvalid   : std_ulogic;
  signal s0_axi_bready   : std_ulogic                     := '0';
  signal s0_axi_bresp    : std_ulogic_vector(1 downto 0);
  signal s0_axi_arvalid  : std_ulogic                     := '0';
  signal s0_axi_arready  : std_ulogic;
  signal s0_axi_araddr   : std_ulogic_vector(31 downto 0) := x"00000000";
  signal s0_axi_arprot   : std_ulogic_vector(2 downto 0)  := "000";
  signal s0_axi_rvalid   : std_ulogic;
  signal s0_axi_rready   : std_ulogic                     := '0';
  signal s0_axi_rdata    : std_ulogic_vector(31 downto 0);
  signal s0_axi_rresp    : std_ulogic_vector(1 downto 0);
  signal reg_00_o        : std_ulogic_vector(31 downto 0);
  signal reg_01_o        : std_ulogic_vector(31 downto 0);
  signal reg_02_o        : std_ulogic_vector(31 downto 0);
  signal reg_03_o        : std_ulogic_vector(31 downto 0);
  signal reg_04_o        : std_ulogic_vector(31 downto 0);
  signal reg_05_o        : std_ulogic_vector(31 downto 0);
  signal reg_06_o        : std_ulogic_vector(31 downto 0);
  signal reg_07_o        : std_ulogic_vector(31 downto 0);
  signal reg_08_o        : std_ulogic_vector(31 downto 0);
  signal reg_09_o        : std_ulogic_vector(31 downto 0);
  signal reg_0A_o        : std_ulogic_vector(31 downto 0);
  signal reg_0B_o        : std_ulogic_vector(31 downto 0);
  signal reg_0C_o        : std_ulogic_vector(31 downto 0);
  signal reg_0D_o        : std_ulogic_vector(31 downto 0);
  signal reg_0E_o        : std_ulogic_vector(31 downto 0);
  signal reg_0F_o        : std_ulogic_vector(31 downto 0);
  signal reg_00_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_01_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_02_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_03_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_04_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_05_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_06_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_07_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_08_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_09_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_0A_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_0B_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_0C_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_0D_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_0E_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_0F_update_i : std_ulogic_vector(31 downto 0) := x"00000000";
  signal reg_00_hwwe_i   : std_ulogic                     := '0';
  signal reg_01_hwwe_i   : std_ulogic                     := '0';
  signal reg_02_hwwe_i   : std_ulogic                     := '0';
  signal reg_03_hwwe_i   : std_ulogic                     := '0';
  signal reg_04_hwwe_i   : std_ulogic                     := '0';
  signal reg_05_hwwe_i   : std_ulogic                     := '0';
  signal reg_06_hwwe_i   : std_ulogic                     := '0';
  signal reg_07_hwwe_i   : std_ulogic                     := '0';
  signal reg_08_hwwe_i   : std_ulogic                     := '0';
  signal reg_09_hwwe_i   : std_ulogic                     := '0';
  signal reg_0A_hwwe_i   : std_ulogic                     := '0';
  signal reg_0B_hwwe_i   : std_ulogic                     := '0';
  signal reg_0C_hwwe_i   : std_ulogic                     := '0';
  signal reg_0D_hwwe_i   : std_ulogic                     := '0';
  signal reg_0E_hwwe_i   : std_ulogic                     := '0';
  signal reg_0F_hwwe_i   : std_ulogic                     := '0';

begin

  dummy <= '0';
  s0_axi_aclk <= NOT td_oscillator(4, 2, 0);

  s0_axi_i.s0_axi_aresetn <= s0_axi_aresetn;
  s0_axi_i.s0_axi_awvalid <= s0_axi_awvalid;
  s0_axi_i.s0_axi_awaddr  <= s0_axi_awaddr;
  s0_axi_i.s0_axi_awprot  <= s0_axi_awprot;
  s0_axi_i.s0_axi_wvalid  <= s0_axi_wvalid;
  s0_axi_i.s0_axi_wdata   <= s0_axi_wdata;
  s0_axi_i.s0_axi_wstrb   <= s0_axi_wstrb;
  s0_axi_i.s0_axi_bready  <= s0_axi_bready;
  s0_axi_i.s0_axi_arvalid <= s0_axi_arvalid;
  s0_axi_i.s0_axi_araddr  <= s0_axi_araddr;
  s0_axi_i.s0_axi_arprot  <= s0_axi_arprot;
  s0_axi_i.s0_axi_rready  <= s0_axi_rready;
  s0_axi_awready          <= s0_axi_o.s0_axi_awready;
  s0_axi_wready           <= s0_axi_o.s0_axi_wready;
  s0_axi_bvalid           <= s0_axi_o.s0_axi_bvalid;
  s0_axi_bresp            <= s0_axi_o.s0_axi_bresp;
  s0_axi_arready          <= s0_axi_o.s0_axi_arready;
  s0_axi_rvalid           <= s0_axi_o.s0_axi_rvalid;
  s0_axi_rdata            <= s0_axi_o.s0_axi_rdata;
  s0_axi_rresp            <= s0_axi_o.s0_axi_rresp;

  axi_regs : entity work.axi_regs_32
    generic map (
      REG_00_WE_MASK     => x"FFFFFFFF",
      REG_01_WE_MASK     => x"00000000",
      REG_02_WE_MASK     => x"AAAAAAAA",
      REG_03_WE_MASK     => x"55555555",
      REG_04_WE_MASK     => x"FFFFFFFF",
      REG_05_WE_MASK     => x"00000000",
      REG_06_WE_MASK     => x"AAAAAAAA",
      REG_07_WE_MASK     => x"55555555",
      REG_08_WE_MASK     => x"FFFFFFFF",
      REG_09_WE_MASK     => x"00000000",
      REG_0A_WE_MASK     => x"AAAAAAAA",
      REG_0B_WE_MASK     => x"55555555",
      REG_0C_WE_MASK     => x"FFFFFFFF",
      REG_0D_WE_MASK     => x"00000000",
      REG_0E_WE_MASK     => x"AAAAAAAA",
      REG_0F_WE_MASK     => x"55555555",
      REG_00_HWWE_MASK   => x"00000000",
      REG_01_HWWE_MASK   => x"00000000",
      REG_02_HWWE_MASK   => x"00000000",
      REG_03_HWWE_MASK   => x"00000000",
      REG_04_HWWE_MASK   => x"FFFFFFFF",
      REG_05_HWWE_MASK   => x"FFFFFFFF",
      REG_06_HWWE_MASK   => x"FFFFFFFF",
      REG_07_HWWE_MASK   => x"FFFFFFFF",
      REG_08_HWWE_MASK   => x"AAAAAAAA",
      REG_09_HWWE_MASK   => x"AAAAAAAA",
      REG_0A_HWWE_MASK   => x"AAAAAAAA",
      REG_0B_HWWE_MASK   => x"AAAAAAAA",
      REG_0C_HWWE_MASK   => x"55555555",
      REG_0D_HWWE_MASK   => x"55555555",
      REG_0E_HWWE_MASK   => x"55555555",
      REG_0F_HWWE_MASK   => x"55555555",
      REG_00_STICKY_MASK => x"00000000",
      REG_01_STICKY_MASK => x"FFFFFFFF",
      REG_02_STICKY_MASK => x"00000000",
      REG_03_STICKY_MASK => x"AAAA5555",
      REG_04_STICKY_MASK => x"00000000",
      REG_05_STICKY_MASK => x"FFFFFFFF",
      REG_06_STICKY_MASK => x"00000000",
      REG_07_STICKY_MASK => x"AAAA5555",
      REG_08_STICKY_MASK => x"00000000",
      REG_09_STICKY_MASK => x"FFFFFFFF",
      REG_0A_STICKY_MASK => x"00000000",
      REG_0B_STICKY_MASK => x"AAAA5555",
      REG_0C_STICKY_MASK => x"00000000",
      REG_0D_STICKY_MASK => x"FFFFFFFF",
      REG_0E_STICKY_MASK => x"00000000",
      REG_0F_STICKY_MASK => x"AAAA5555"
    )

    port map (
      s0_axi_aclk     => s0_axi_aclk,
      s0_axi_i        => s0_axi_i,
      s0_axi_o        => s0_axi_o,
      reg_00_o        => reg_00_o,
      reg_01_o        => reg_01_o,
      reg_02_o        => reg_02_o,
      reg_03_o        => reg_03_o,
      reg_04_o        => reg_04_o,
      reg_05_o        => reg_05_o,
      reg_06_o        => reg_06_o,
      reg_07_o        => reg_07_o,
      reg_08_o        => reg_08_o,
      reg_09_o        => reg_09_o,
      reg_0A_o        => reg_0A_o,
      reg_0B_o        => reg_0B_o,
      reg_0C_o        => reg_0C_o,
      reg_0D_o        => reg_0D_o,
      reg_0E_o        => reg_0E_o,
      reg_0F_o        => reg_0F_o,
      reg_00_update_i => reg_00_update_i,
      reg_01_update_i => reg_01_update_i,
      reg_02_update_i => reg_02_update_i,
      reg_03_update_i => reg_03_update_i,
      reg_04_update_i => reg_04_update_i,
      reg_05_update_i => reg_05_update_i,
      reg_06_update_i => reg_06_update_i,
      reg_07_update_i => reg_07_update_i,
      reg_08_update_i => reg_08_update_i,
      reg_09_update_i => reg_09_update_i,
      reg_0A_update_i => reg_0A_update_i,
      reg_0B_update_i => reg_0B_update_i,
      reg_0C_update_i => reg_0C_update_i,
      reg_0D_update_i => reg_0D_update_i,
      reg_0E_update_i => reg_0E_update_i,
      reg_0F_update_i => reg_0F_update_i,
      reg_00_hwwe_i   => reg_00_hwwe_i,
      reg_01_hwwe_i   => reg_01_hwwe_i,
      reg_02_hwwe_i   => reg_02_hwwe_i,
      reg_03_hwwe_i   => reg_03_hwwe_i,
      reg_04_hwwe_i   => reg_04_hwwe_i,
      reg_05_hwwe_i   => reg_05_hwwe_i,
      reg_06_hwwe_i   => reg_06_hwwe_i,
      reg_07_hwwe_i   => reg_07_hwwe_i,
      reg_08_hwwe_i   => reg_08_hwwe_i,
      reg_09_hwwe_i   => reg_09_hwwe_i,
      reg_0A_hwwe_i   => reg_0A_hwwe_i,
      reg_0B_hwwe_i   => reg_0B_hwwe_i,
      reg_0C_hwwe_i   => reg_0C_hwwe_i,
      reg_0D_hwwe_i   => reg_0D_hwwe_i,
      reg_0E_hwwe_i   => reg_0E_hwwe_i,
      reg_0F_hwwe_i   => reg_0F_hwwe_i
      );

end axi_regs_tb;
