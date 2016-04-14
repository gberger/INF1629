-- TITLE: banco
-- AUTHOR: Guilherme Berger <guilherme.berger@gmail.com>
-- DATE: 12/04/2016
-- VERSION: 1.0
-- CONTENT: ~200 lines



-- Função auxiliar para mostrar uma pergunta e ler o input do usuário
function prompt (text)
  print(text)
  return io.read()
end


-- Função auxiliar para gerar um número de conta válido
function generate_account_num(accounts)
  return #accounts + 1
end


-- Função auxiliar para validar um valor financeiro digitado
function validate_amount(number)
  if number == nil then
    return false
  elseif number > 0 then
    return true
  else
    return false
  end
end


-- Mostra o saldo da conta dada
function io_account_balance(account)
  print('Seu saldo é: ' .. account.balance)
end

-- Pede o valor do depósito 
-- Realiza o depósito na conta dada, se possível
function io_account_deposit(account)
  local amount = tonumber(prompt('Valor do depósito: '))

  if not validate_amount(amount) then
    print('Valor inválido ou negativo.')
    return
  end

  account.balance = account.balance + amount
  print('Depósito realizado.')
end


-- Pede o valor do saque
-- Realiza o saque na conta dada, se possível
function io_account_withdraw(account)
  local amount = tonumber(prompt('Valor do saque: '))

  if not validate_amount(amount) then
    print('Valor inválido ou negativo.')
    return
  end
  
  account.balance = account.balance - amount
  print('Saque realizado.')
end


-- Interage com um usuário, dado a sua conta logada
-- Mostra o menu da conta
-- Chama a função correspondente à opção escolhida
-- O menu se repete até o usuário escolher sair
function io_account(account)
  while true do
    print()
    print('>>> Bem-vindo à sua conta, ' .. account.name .. ' <<<')
    print('C) Consultar saldo')
    print('D) Depositar')
    print('S) Sacar')
    print('X) Sair')
    local option = prompt('Selecione uma das opções: '):upper()
    if option == 'C' then
      io_account_balance(account)
    elseif option == 'D' then
      io_account_deposit(account)
    elseif option == 'S' then
      io_account_withdraw(account)
    elseif option == 'X' then
      return
    else
      print('Opção inválida.')
    end
  end
end


-- Pede os dados da conta do usuário
-- Se válido, chama a função de interação com a conta
function io_access_account (accounts)
  print()
  print('*** Acessar conta ***')
  local account_num = tonumber(prompt('Numero da conta: ', '*number'))

  local account = accounts[account_num]
  if account == nil then
    print('Conta não existe.')
    return
  end

  local pw = prompt('Senha:')
  if account.pw ~= pw then
    print('Senha inválida.')
    return
  end

  io_account(account)
end


-- Pede os dados da conta do favorecido
-- Se válido, pede o valor do depósito
-- Se válido, realiza o depósito
function io_deposit (accounts)
  print()
  print('*** Depositar em conta de terceiro ***')
  local account_num = tonumber(prompt('Numero da conta: '))

  local account = accounts[account_num]
  if account == nil then
    print('Conta não existe.')
    return
  end

  local cpf = prompt('CPF do favorecido: ')
  if account.cpf ~= cpf then
    print('CPF inválido.')
    return
  end

  io_account_deposit(account)
end


-- Pede os dados cadastrais ao usuário e registra sua nova conta
function io_new_account(accounts)
  print()
  print('*** Abrir nova conta ***')
  local name = prompt('Nome: ')
  local cpf = prompt('CPF: ')
  local pw = prompt('Escolha uma senha: ')
  local account_num = generate_account_num(accounts)

  print('O número da sua nova conta é: ' .. account_num)

  accounts[account_num] = {
    name = name,
    cpf = cpf,
    pw = pw,
    balance = 0
  }
end


-- Função principal
-- Inicializa a tabela de contas
-- Mostra as opções e lê a escolhida
-- Chama a função correspondente à opção escolhida
-- O menu se repete até o usuário escolher sair
function main()
  math.randomseed(os.time())

  local accounts = {}

  print('Bem-vindo ao LuaBank.')

  while true do
    print()
    print('*** MENU ***')
    print('A) Acessar conta')
    print('D) Depositar em conta de terceiro')
    print('N) Abrir nova conta')
    print('X) Sair')
    local option = prompt('Selecione uma das opções: '):upper()
    if option == 'A' then
      io_access_account(accounts)
    elseif option == 'D' then
      io_deposit(accounts)
    elseif option == 'N' then
      io_new_account(accounts)
    elseif option == 'X' then
      return
    else
      print('Opção inválida.')
    end
  end
end

-- inicia a aplicação
main()