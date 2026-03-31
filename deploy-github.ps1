# ============================================================
# SCRIPT DE DEPLOY - RP Golden Clinic
# Execute no PowerShell como Administrador
# ============================================================

Write-Host ""
Write-Host "=======================================" -ForegroundColor Yellow
Write-Host "   RP Golden Clinic - Deploy GitHub    " -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Yellow
Write-Host ""

# ── 1. SOLICITAR DADOS DO USUARIO ──────────────────────────
$githubUser = Read-Host "Digite seu usuario do GitHub (ex: mariasilva)"
$repoName   = Read-Host "Digite o nome do repositorio (ex: rp-golden-clinic)"
$pastaLocal = Read-Host "Digite o caminho da pasta do projeto (ex: C:\Sites\rp-golden-clinic)"

Write-Host ""
Write-Host ">> Configurando projeto em: $pastaLocal" -ForegroundColor Cyan

# ── 2. CRIAR PASTA SE NAO EXISTIR ──────────────────────────
if (-not (Test-Path $pastaLocal)) {
    New-Item -ItemType Directory -Path $pastaLocal | Out-Null
    Write-Host "   Pasta criada com sucesso." -ForegroundColor Green
} else {
    Write-Host "   Pasta ja existe, continuando..." -ForegroundColor Gray
}

Set-Location $pastaLocal

# ── 3. VERIFICAR GIT ───────────────────────────────────────
Write-Host ""
Write-Host ">> Verificando instalacao do Git..." -ForegroundColor Cyan
try {
    git --version | Out-Null
    Write-Host "   Git encontrado!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "   ERRO: Git nao encontrado." -ForegroundColor Red
    Write-Host "   Baixe e instale em: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "   Depois execute este script novamente." -ForegroundColor Yellow
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# ── 4. INICIALIZAR GIT ─────────────────────────────────────
Write-Host ""
Write-Host ">> Inicializando repositorio Git..." -ForegroundColor Cyan

if (-not (Test-Path ".git")) {
    git init
    Write-Host "   Repositorio inicializado." -ForegroundColor Green
} else {
    Write-Host "   Git ja inicializado, continuando..." -ForegroundColor Gray
}

git branch -M main

# ── 5. CRIAR README ────────────────────────────────────────
Write-Host ""
Write-Host ">> Criando README.md..." -ForegroundColor Cyan

$readme = @"
# RP Golden Clinic

Site institucional e blog da **RP Golden Clinic** - Dra. Roberta Castro Peres | CRM 160891.

## Estrutura

\`\`\`
/
├── index.html          # Pagina principal do site
├── blog.html           # Blog com artigos
├── admin.html          # Painel administrativo do blog
└── README.md
\`\`\`

## Admin

Acesse \`/admin.html\` com as credenciais configuradas no painel.

---
Desenvolvido para RP Golden Clinic.
"@

$readme | Out-File -FilePath "README.md" -Encoding UTF8
Write-Host "   README.md criado." -ForegroundColor Green

# ── 6. VERIFICAR ARQUIVOS HTML ─────────────────────────────
Write-Host ""
Write-Host ">> Verificando arquivos HTML do blog..." -ForegroundColor Cyan

$blogFile  = "blog.html"
$adminFile = "admin.html"

if (-not (Test-Path $blogFile)) {
    Write-Host ""
    Write-Host "   ATENCAO: $blogFile nao encontrado na pasta." -ForegroundColor Yellow
    Write-Host "   Copie o arquivo blog-rp-golden-clinic.html para esta pasta" -ForegroundColor Yellow
    Write-Host "   e renomeie para: blog.html" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "   Pressione ENTER apos copiar o arquivo para continuar"
}

if (-not (Test-Path $adminFile)) {
    Write-Host ""
    Write-Host "   ATENCAO: $adminFile nao encontrado na pasta." -ForegroundColor Yellow
    Write-Host "   Copie o arquivo admin-rp-golden-clinic.html para esta pasta" -ForegroundColor Yellow
    Write-Host "   e renomeie para: admin.html" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "   Pressione ENTER apos copiar o arquivo para continuar"
}

# ── 7. COMMIT INICIAL ──────────────────────────────────────
Write-Host ""
Write-Host ">> Fazendo commit inicial..." -ForegroundColor Cyan

git add .
git commit -m "feat: blog e admin RP Golden Clinic - primeira versao"
Write-Host "   Commit realizado." -ForegroundColor Green

# ── 8. CONECTAR AO GITHUB ─────────────────────────────────
Write-Host ""
Write-Host ">> Conectando ao GitHub..." -ForegroundColor Cyan

$remoteUrl = "https://github.com/$githubUser/$repoName.git"

# Remove remote existente se houver
git remote remove origin 2>$null

git remote add origin $remoteUrl
Write-Host "   Remote configurado: $remoteUrl" -ForegroundColor Green

# ── 9. PUSH ────────────────────────────────────────────────
Write-Host ""
Write-Host ">> Enviando arquivos para o GitHub..." -ForegroundColor Cyan
Write-Host "   (sera solicitado seu usuario e token do GitHub)" -ForegroundColor Gray
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host "   SUCESSO! Projeto no GitHub!         " -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Repositorio: https://github.com/$githubUser/$repoName" -ForegroundColor Cyan
    Write-Host "   Blog:        https://github.com/$githubUser/$repoName/blob/main/blog.html" -ForegroundColor Cyan
    Write-Host "   Admin:       https://github.com/$githubUser/$repoName/blob/main/admin.html" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Red
    Write-Host "   ERRO ao enviar para o GitHub        " -ForegroundColor Red
    Write-Host "=======================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possiveis solucoes:" -ForegroundColor Yellow
    Write-Host "1. Confirme que o repositorio foi criado em github.com/new" -ForegroundColor White
    Write-Host "2. Use um Token de Acesso Pessoal como senha" -ForegroundColor White
    Write-Host "   Crie em: GitHub > Settings > Developer Settings > Personal Access Tokens" -ForegroundColor Gray
    Write-Host "3. Verifique seu usuario: $githubUser" -ForegroundColor White
    Write-Host ""
}

Read-Host "Pressione ENTER para fechar"
