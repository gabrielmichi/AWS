--Listar Diretórios
--As DBA:
select * from dba_directories;

--As normal user:
select * from all_directories;


--Criar diretório
begin
 rdsadmin.rdsadmin_util.create_directory(p_directory_name => 'DIRETORIO');
end;
/

--Conceder e retirar Permissões de Leitura e escrita no diretório
grant read,write,execute on directory DIRETORIO to USUARIO;
REVOKE read,write on directory DIRETORIO FROM USUARIO;

--Criar um subdiretório
CREATE DIRECTORY DIRETORIO AS '/rdsdbdata/userdirs/03';

--Listar todos os arquivos no diretório
select * from table
    (rdsadmin.rds_file_util.listdir(p_directory => 'DIRETORIO'));

--Consultar arquivos TXT no diretório
select filename from table(rdsadmin.rds_file_util.listdir(p_directory => 'ARQUIVO'))
                  where (filename like '%.TXT' OR filename  like '%.txt');

--Ler Arquivo
select * from table
    (rdsadmin.rds_file_util.read_text_file(
        p_directory => 'DIRETORIO',
        p_filename  => 'ARQUIVO.txt'));

--Verificar permissões no diretório

--As DBA:
select * from dba_tab_privs where type = 'DIRECTORY';

--As normal user:
select * from user_tab_privs where type = 'DIRECTORY';


--Remover Arquivo dentro do diretório
begin
 UTL_FILE.FREMOVE(p_directory_name => 'DIRETORIO', 'ARQUIVO');
end;
/

--Remover todos os arquivos do diretório
begin
    for i in (select filename from 
    table(RDSADMIN.RDS_FILE_UTIL.LISTDIR('MY_DIR')) where type='file')
    loop
    UTL_FILE.FREMOVE ('MY_DIR', i.filename);
    end loop;
end;
/

--Apagar Diretório
drop directory DIRETORIO;