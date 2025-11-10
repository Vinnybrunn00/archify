class Hardware {
  final String cpuInfo = '/proc/cpuinfo';
  final String meminfo = '/proc/meminfo';
  final String cpuSysteminfo = '/sys/devices/system/cpu';
}

/// Mapeamento de SoCs conhecidos por fabricante.
/// As chaves são os códigos técnicos (ex: "SM8450"),
/// e os valores são os nomes comerciais.
const Map<String, String> socModels = {
  // 🏁 Qualcomm Snapdragon
  "SM8650": "Snapdragon 8 Gen 3",
  "SM8550": "Snapdragon 8 Gen 2",
  "SM8475": "Snapdragon 8+ Gen 1",
  "SM8450": "Snapdragon 8 Gen 1",
  "SM8350": "Snapdragon 888",
  "SM8250": "Snapdragon 865",
  "SM8150": "Snapdragon 855",
  "SM7325": "Snapdragon 778G",
  "SM6375": "Snapdragon 695",
  "SM6225": "Snapdragon 680",
  "SM4350": "Snapdragon 480 5G",
  "SDM660": "Snapdragon 660",
  "SDM632": "Snapdragon 632",
  "SDM450": "Snapdragon 450",
  "MSM8998": "Snapdragon 835",
  "MSM8996": "Snapdragon 820 / 821",
  "MSM8937": "Snapdragon 430",

  // 🧠 MediaTek Dimensity & Helio
  "MT6989": "Dimensity 9300+",
  "MT6983": "Dimensity 9000",
  "MT6893": "Dimensity 1200",
  "MT6889": "Dimensity 1000+",
  "MT6877": "Dimensity 920",
  "MT6853": "Dimensity 720",
  "MT6785": "Helio G90T",
  "MT6768": "Helio G80",
  "MT6765": "Helio P35",
  "MT6753": "Helio P23",
  "MT6739": "MT6739 (básico)",
  "MT6771": "Helio P60",
  "MT6779": "Helio P90",

  // ⚡ Samsung Exynos
  "Exynos9830": "Exynos 990",
  "Exynos2100": "Exynos 2100",
  "Exynos2200": "Exynos 2200",
  "Exynos2400": "Exynos 2400",
  "Exynos1080": "Exynos 1080",
  "Exynos9810": "Exynos 9810",
  "Exynos8895": "Exynos 8895",
  "Exynos7420": "Exynos 7420",

  // 🧬 Google Tensor
  "GS101": "Google Tensor (1ª geração)",
  "GS201": "Google Tensor G2",
  "GS301": "Google Tensor G3",

  // 🐉 Huawei HiSilicon Kirin
  "Kirin9000": "Kirin 9000",
  "Kirin9000S": "Kirin 9000S",
  "Kirin990": "Kirin 990",
  "Kirin980": "Kirin 980",
  "Kirin970": "Kirin 970",
  "Kirin810": "Kirin 810",
  "Kirin710": "Kirin 710",

  // 🍎 Apple (para referência, raramente aplicável em Android)
  "A17": "Apple A17 Pro",
  "A16": "Apple A16 Bionic",
  "A15": "Apple A15 Bionic",
  "A14": "Apple A14 Bionic",
};
