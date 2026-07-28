# =============================================================================
# render_pim.R — Automação da Nota Informativa PIM-PF - Kevin Lima, Leo Ono, Lucca Costa
# =============================================================================

# ── 0. Configuração de caminhos ───────────────────────────────────────────────
rmd_path <- "C:/Users/larry/OneDrive/Documentos/FGV/PIM/pim_relatorio.Rmd"

# Fallback: usa o diretório de trabalho se não conseguir resolver o caminho
if (!file.exists(rmd_path)) {
  rmd_path <- file.path(getwd(), "pim_relatorio.Rmd")
}

output_dir <- file.path(dirname(rmd_path), "relatorios")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

log_path   <- file.path(output_dir, "render_log.txt")

# ── Pandoc (necessário fora do RStudio) ──────────────────────────────────────
Sys.setenv(RSTUDIO_PANDOC = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools")

# ── 1. Função auxiliar de log ─────────────────────────────────────────────────
log_msg <- function(..., level = "INFO") {
  ts  <- format(Sys.time(), "[%Y-%m-%d %H:%M:%S]")
  msg <- paste0(ts, " [", level, "] ", paste(..., sep = " "))
  message(msg)
  cat(msg, "\n", file = log_path, append = TRUE)
}

# ── 2. Verificações de segurança (minimiza risco de falha silenciosa) ─────────
log_msg("=== Iniciando automação PIM-PF ===")

## 2a. O arquivo .Rmd existe?
if (!file.exists(rmd_path)) {
  log_msg("ERRO: arquivo não encontrado:", rmd_path, level = "ERROR")
  quit(status = 1)
}
log_msg("Arquivo .Rmd localizado:", rmd_path)

## 2b. Pacotes obrigatórios instalados?
pkgs_necessarios <- c("rmarkdown", "sidrar", "tidyverse", "lubridate",
                      "zoo", "scales", "kableExtra")

pkgs_faltando <- pkgs_necessarios[
  !vapply(pkgs_necessarios, requireNamespace, logical(1), quietly = TRUE)
]

if (length(pkgs_faltando) > 0) {
  log_msg(
    "Pacotes ausentes:", paste(pkgs_faltando, collapse = ", "),
    "| Instale com: install.packages(c('",
    paste(pkgs_faltando, collapse = "', '"), "'))",
    level = "ERROR"
  )
  quit(status = 1)
}
log_msg("Todos os pacotes disponíveis.")

## 2c. Conexão com a API do SIDRA disponível?
log_msg("Testando conectividade com SIDRA-IBGE...")
teste_conexao <- tryCatch({
  sidrar::get_sidra(x = 8888, variable = 12606,
                    period = "202401", geo = "Brazil", category = "all")
  TRUE
}, error = function(e) {
  log_msg("AVISO: falha no teste de conexão SIDRA:", conditionMessage(e), level = "WARN")
  FALSE  # continua mesmo assim — pode ser instabilidade momentânea
})

if (!teste_conexao) {
  log_msg("Prosseguindo apesar da instabilidade na API (cache pode estar disponível).", level = "WARN")
} else {
  log_msg("Conexão com SIDRA-IBGE confirmada.")
}

# ── 3. Compilação do relatório ────────────────────────────────────────────────
nome_arquivo  <- sprintf("PIM_PF_%s.html", format(Sys.Date(), "%Y%m"))
output_html   <- file.path(output_dir, nome_arquivo)
output_latest <- file.path(output_dir, "PIM_PF_LATEST.html")

log_msg("Iniciando knit:", nome_arquivo)

resultado <- withCallingHandlers(
  # withCallingHandlers captura warnings SEM interromper a execução —
  # ao contrário do tryCatch, que para o fluxo ao encontrar um warning.
  # invokeRestart("muffleWarning") aqui suprime o warning e continua normalmente.
  tryCatch({
    rmarkdown::render(
      input         = rmd_path,
      output_format = "html_document",
      output_file   = output_html,
      envir         = new.env(parent = globalenv()),
      quiet         = FALSE
    )
    "OK"
  }, error = function(e) {
    # Erros fatais ainda são capturados pelo tryCatch interno
    paste("ERRO:", conditionMessage(e))
  }),
  warning = function(w) {
    # Loga o aviso e suprime — o render continua sem interrupção
    log_msg("Aviso durante render:", conditionMessage(w), level = "WARN")
    invokeRestart("muffleWarning")
  }
)

# ── 4. Verificação pós-compilação ─────────────────────────────────────────────
if (resultado == "OK" && file.exists(output_html)) {
  tamanho_kb <- round(file.info(output_html)$size / 1024, 1)
  file.copy(output_html, output_latest, overwrite = TRUE)
  
  log_msg(sprintf("Sucesso! Relatório gerado: %s (%.1f KB)", nome_arquivo, tamanho_kb))
  log_msg("Cópia LATEST atualizada:", output_latest)
  
} else {
  log_msg("FALHA na geração do relatório:", resultado, level = "ERROR")
  log_msg("Verifique o log acima e o arquivo .Rmd.", level = "ERROR")
  quit(status = 1)
}

log_msg("=== Automação concluída ===")