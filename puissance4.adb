------------------------------------
-- TODO
-- 1. Faire des pré/post conditions
-- 2. Faire des tests
------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Puissance4(Tableau: in T_Tableau) is

    -- Exercice 1
    -- Il me dit "skipped token type" je suis pas sur qu'on devrait le mettre dans le is faut voir
    nb_lignes: constant Integer := 6;
    nb_colonnes: constant Integer := 7;

    type T_Grille is array(1..nb_lignes, 1..nb_colonnes) of T_Valeur;

    type T_Valeur is (VIDE, JAUNE, ROUGE);

    type T_Piece is record 
        coord_x: Integer;
        coord_y: Integer;
        valeur: T_Valeur;
    end record;    

    -- Exercice 2
    procedure Vider_Grille(Grille: in out T_Grille) is
    begin
        for row in 1..Grille.nb_lignes loop
            for column in 1..Grille.nb_colonnes loop
                Grille(row, column) := VIDE;
            end loop;
        end loop;
    end Vider_Grille;

    -- Exercice 3
    procedure Affichage_Simple(Grille: in T_Grille) is
    begin
        for row in 1..Grille.nb_lignes loop
            for column in 1..Grille.nb_colonnes loop
                case grille(row, column).valeur is
                    when VIDE => Put(" ");
                    when JAUNE => Put("*");
                    when ROUGE => Put("o");
                end case;
            end loop;
            Put("\n");
        end loop;
    end Affichage_Simple;

    procedure Affichage_1(Grille: in T_Grille) is begin
        Affichage_Simple(Grille);
        Put("\n");
        for column in 1..Grille.nb_colonnes loop
            Put(column);
        end loop;
        Put("\n");
    end;

    procedure Affichage_2(Grille: in T_Grille) is begin
        Affichage_Simple(Grille);
        Put("\n");
        for column in 1..Grille.nb_colonnes loop
            Put("-");
        end loop;
        Put("\n");
    end Affichage_2;    
    
    procedure Affichage_Intermediaire(Grille: in T_Grille; Symbole_Jaune: in Character; Symbole_Rouge: in Character) is begin
        -- Header
        for i in 0..(Grille.nb_colonnes + 1) loop
            if (i = 0) or (i = (Grille.nb_colonnes + 1)) then
                Put(" ");
            else 
                Put(i);
            end if;
        end loop;
        Put("\n");

        -- Playfield
        for ligne in 1..Grille.nb_colonnes loop
            for i in 0..(Grille.nb_colonnes + 1) loop
            if (i = 0) or (i = Grille.nb_colonnes + 1) then
                Put(nb_colonnes+1-i);
            else 
                case Grille(ligne, i).valeur is
                when VIDE => Put(" ");
                when JAUNE => Put(Symbole_Jaune); 
                when ROUGE => Put(Symbole_Rouge);
                end case;
            end if;
            end loop;
            Put("\n");
        end loop;

        -- Footer
        for i in 0..(Grille.nb_colonnes + 1) loop
            if (i = 0) or (i = Grille.nb_colonnes + 1) then
                Put(" ");
            else 
                Put(i);
            end if;
        end loop;
        Put("\n");
    end Affichage_intermediaire;
    
    procedure Affichage_3(Grille: T_Grille) is begin
        Affichage_intermediaire(Grille, Symbole_Jaune => "*", Symbole_Rouge => "o");
    end;

    procedure Affichage_4(Grille: T_Grille) is begin
        Affichage_intermediaire(Grille, Symbole_Jaune => "X", Symbole_Rouge => "O");
    end;

    procedure Affichage_5(Grille: T_Grille) is 
    begin
        -- Header
        for i in 0..(Grille.nb_colonnes + 1) loop
            if (i = 0) or (i = (Grille.nb_colonnes + 1)) then
                Put("   \n");
            else
                Put(" "); Put(i, 1); Put(" \n");
            end if;
        end loop;
        
        -- Playfield
        for i in 1..(Grille.nb_lignes * 2) loop
        for j in 0..(Grille.nb_colonnes + 1) loop
            if i=0 or i=Grille.nb_colonnes+1 then
                Put(" "); Put(Grille.nb_lignes - i/2, 1); Put(" ");
            else
                -- quand le numéro de la ligne est impair, on est sur un séparateur. sinon, on est sur la ligne contenant le centre d'une case.
                if j mod 2 = 0 then
                    Put("|---|");
                else
                    Put("| ");
                    case Grille(i, j).valeur is
                        when VIDE => Put(" ");
                        when JAUNE => Put("X");
                        when ROUGE => Put("O");
                    end case;
                    Put(" |");
                end if;
            end if;
            end loop;
            Put("\n");
        end loop;

        -- Footer
        for i in 0..(Grille.nb_colonnes + 1) loop
            if (i = 0) or (i = (Grille.nb_colonnes + 1)) then
                Put("   \n");
            else
                Put(" "); Put(i, 1); Put(" \n");
            end if;
        end loop;
    end;

    -- Exercice 4
    -- Définition de types
    type T_Colonnes is array(1..Grille.nb_colonnes) of Integer;
    type T_Etat_Colonnes is (LIBRE, OCCUPE);
    
    -- On regarde si on peut jouer sur une certaine colonne avec un système de compteur sur chaque colonne
    function Coup_Est_Possible(Grille: in T_Grille; Colonne: in Integer; Etat_Colonne: in T_Etat_Colonne; Piece: in T_Piece) return Boolean is
        Compteur : Integer := 0;
    begin
        Compteur := 0;
        for row in 1..Grille.nb_lignes loop
            if (Piece /= VIDE) then
                Compteur := Compteur + 1;
            else
                null;
            end if;
        end loop;
        return Compteur = Grille.nb_lignes;
    end Coup_Est_Possible;
    
    -- Exercice 5
    procedure Lacher_Jeton(Grille: in out T_Grille; Colonnes: in T_Colonnes) is
        Piece: T_Piece;
        Colonne: Integer;
    begin
        Put("Dans quelle colonne voulez-vous lâcher la pièce ?");
        Get(Colonne);
        while Colonne = OCCUPE loop
            Put("Cette colonne est occupée, veuillez en choisir une autre !");
            Get(Colonne);
        end loop;

    end Lacher_Jeton;


    -- Exercice 6
    procedure Compter_Jetons_Alignes(Grille: in T_Grille) is

        -- coordonnées du jeton choisi par l'utilisateur
        jeton_y: Integer; 
        jeton_x: Integer;
        
        -- coordonnées du jeton que l'on compare au jeton choisi actuellement
        check_y: Integer;
        check_x: Integer;
        
        Jeton: T_Jeton;
        AlignementVersGauche: Integer;
        AlignementVersDroite: Integer;
        AlignementVersHaut: Integer;
        AlignementVersBas: Integer;
        AlignementVersGaucheHaut: Integer;
        AlignementVersGaucheBas: Integer;
        AlignementVersDroiteHaut: Integer;
        AlignementVersDroite: Integer;
        
    begin
        Put("Quelle est le jeton dont vous voulez observer l'alignement le plus long ?");
        Put("Coordonnée x");
        Get(jeton_y);
        Put("Coordonnée y");
        Get(jeton_x);
        check_x := jeton_x;
        check_y := jeton_y;

        Jeton := Grille(coord_x, coord_y);

        if Jeton.Value = VIDE then Put_Line("Veuillez choisir une case occupée!"); end if;

        -- Recherche vers le haut
        while Grille(check_x, check_y).Value = Jeton.Value and check_y > 1 loop
            check_y := check_y - 1;
            AlignementVersHaut := AlignementVersHaut + 1;
        end loop;

        -- Recherche vers la diagonale droite/haut
        while Grille(check_x, check_y).Value = Jeton.Value and check_x < nb_colonnes and check_y > 1 loop
            check_y := check_y - 1;
            check_x := check_x + 1;
            AlignementVersHaut := AlignementVersHaut + 1;
        end loop;

        -- Recherche vers la droite
        while Grille(check_x, check_y).Value = Jeton.Value and check_y > 1 loop
            check_y := check_y - 1;
            AlignementVersHaut := AlignementVersHaut + 1;
        end loop;

        -- Recherche vers le bas
        while Grille(check_x, check_y).Value = Jeton.Value and check_y < nb_lignes loop
            check_y := check_y + 1;
            AlignementVersBas := AlignementVersBas + 1;
        end loop;


    end Compter_Jetons_Alignes;

    -- Exercice 7 & 8
    procedure Conseil_Colonne(Grille: in T_Grille) is
        
    begin
        
    end Conseil_Colonne;

begin

    -- Exercice 9

end Puissance4;
