toc.dat                                                                                             0000600 0004000 0002000 00000073415 14352315464 0014460 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP       '                    z            gym    15.0    15.0 m    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         �           1262    16637    gym    DATABASE     w   CREATE DATABASE gym WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Turkish_Turkey.1254';
    DROP DATABASE gym;
                postgres    false         �            1255    24857    eski_uyeler()    FUNCTION     �   CREATE FUNCTION public.eski_uyeler() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
	INSERT INTO silinen_kisi (ad ,soyad) values ( OLD.ad, OLD.soyad);
    RETURN NEW;
    END;
	$$;
 $   DROP FUNCTION public.eski_uyeler();
       public          postgres    false         �            1255    24871    kalorihesapla(integer)    FUNCTION     6  CREATE FUNCTION public.kalorihesapla(kisino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    personel RECORD;
    kg NUMERIC;
	kalori INTEGER;
BEGIN
    personel := uyeAra(kisino);
    kg := (SELECT kilo FROM sporcu_bilgileri WHERE id = kisino); 
	kalori:=kg*35;

    RETURN kalori;
END
$$;
 4   DROP FUNCTION public.kalorihesapla(kisino integer);
       public          postgres    false         �            1255    24873    proteinhesapla(integer)    FUNCTION     9  CREATE FUNCTION public.proteinhesapla(kisino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    personel RECORD;
    kg NUMERIC;
	protein INTEGER;
BEGIN
    personel := uyeAra(kisino);
    kg := (SELECT kilo FROM sporcu_bilgileri WHERE id = kisino); 
	protein:=kg*2;

    RETURN protein;
END
$$;
 5   DROP FUNCTION public.proteinhesapla(kisino integer);
       public          postgres    false         �            1255    16915    toplam_kasa()    FUNCTION     \  CREATE FUNCTION public.toplam_kasa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
	kisi_tipi integer;
 	BEGIN
		kisi_tipi:=(SELECT uye_turu FROM odeme ORDER BY id DESC limit 1);
		IF kisi_tipi!=0 THEN
			UPDATE kasa SET toplam=toplam+150;
			RETURN NEW;
		ELSE
			UPDATE kasa SET toplam=toplam+100;
			RETURN NEW;
		END IF;
  	END;
	$$;
 $   DROP FUNCTION public.toplam_kasa();
       public          postgres    false         �            1255    24839    uye_sayisi_arttirma()    FUNCTION     �   CREATE FUNCTION public.uye_sayisi_arttirma() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
	UPDATE toplam_uye_sayisi set toplam_uye=toplam_uye + 1;
	RETURN NEW;
	END;
	$$;
 ,   DROP FUNCTION public.uye_sayisi_arttirma();
       public          postgres    false         �            1255    24843    uye_sayisi_azaltma()    FUNCTION     �   CREATE FUNCTION public.uye_sayisi_azaltma() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
	UPDATE toplam_uye_sayisi set toplam_uye=toplam_uye - 1;
	RETURN NEW;
	END;
	$$;
 +   DROP FUNCTION public.uye_sayisi_azaltma();
       public          postgres    false         �            1255    24863    uyeara(integer)    FUNCTION       CREATE FUNCTION public.uyeara(numara integer) RETURNS TABLE(adi character varying, soyadi character varying, kisitipi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT ad,soyad,kisituru FROM uye
                 WHERE "id" = numara;
END;
$$;
 -   DROP FUNCTION public.uyeara(numara integer);
       public          postgres    false                    1255    24879    yashesapla(integer)    FUNCTION     Y  CREATE FUNCTION public.yashesapla(kisino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    personel RECORD;
    dogumtarihi DATE;
	
BEGIN
    personel := uyeAra(kisino);
    dogumtarihi := (SELECT dogum_tarihi FROM uye WHERE id = kisino); 


    RETURN (SELECT DATE_PART('years', AGE(CURRENT_TIMESTAMP, dogumtarihi)));
END
$$;
 1   DROP FUNCTION public.yashesapla(kisino integer);
       public          postgres    false         �            1255    24890    yedekleme()    FUNCTION     �   CREATE FUNCTION public.yedekleme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
  INSERT INTO "silinen_kisi" 
("ad", "soyad")
VALUES (OLD."ad",OLD."soyad");
    RETURN NEW;
END;
$$;
 "   DROP FUNCTION public.yedekleme();
       public          postgres    false         �            1259    24880    brans    TABLE     b   CREATE TABLE public.brans (
    brans_no integer NOT NULL,
    brans_adi character varying(40)
);
    DROP TABLE public.brans;
       public         heap    postgres    false         �            1259    16823    durum    TABLE     N   CREATE TABLE public.durum (
    id integer NOT NULL,
    bitis_tarihi date
);
    DROP TABLE public.durum;
       public         heap    postgres    false         �            1259    16822    durum_id_seq    SEQUENCE     �   CREATE SEQUENCE public.durum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.durum_id_seq;
       public          postgres    false    225         �           0    0    durum_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.durum_id_seq OWNED BY public.durum.id;
          public          postgres    false    224         �            1259    24673    kisi    TABLE     �   CREATE TABLE public.kisi (
    id integer NOT NULL,
    ad character varying(40) NOT NULL,
    soyad character varying(40) NOT NULL,
    kisituru character varying(40) NOT NULL,
    dogum_tarihi date NOT NULL
);
    DROP TABLE public.kisi;
       public         heap    postgres    false         �            1259    24762    egitmen    TABLE     }   CREATE TABLE public.egitmen (
    id integer,
    mail character varying(40),
    brans_no integer
)
INHERITS (public.kisi);
    DROP TABLE public.egitmen;
       public         heap    postgres    false    232         �            1259    24761    egitmen_id_seq    SEQUENCE     �   CREATE SEQUENCE public.egitmen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.egitmen_id_seq;
       public          postgres    false    236         �           0    0    egitmen_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.egitmen_id_seq OWNED BY public.egitmen.id;
          public          postgres    false    235         �            1259    16870    fiyat    TABLE     J   CREATE TABLE public.fiyat (
    id integer NOT NULL,
    fiyat integer
);
    DROP TABLE public.fiyat;
       public         heap    postgres    false         �            1259    16730    il    TABLE     ^   CREATE TABLE public.il (
    il_no integer NOT NULL,
    il_adi character varying NOT NULL
);
    DROP TABLE public.il;
       public         heap    postgres    false         �            1259    16729    il_il_no_seq    SEQUENCE     �   CREATE SEQUENCE public.il_il_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.il_il_no_seq;
       public          postgres    false    217         �           0    0    il_il_no_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.il_il_no_seq OWNED BY public.il.il_no;
          public          postgres    false    216         �            1259    16744    ilce    TABLE     k   CREATE TABLE public.ilce (
    ilce_no integer NOT NULL,
    ilce_adi character varying,
    il integer
);
    DROP TABLE public.ilce;
       public         heap    postgres    false         �            1259    16743    ilce_ilce_no_seq    SEQUENCE     �   CREATE SEQUENCE public.ilce_ilce_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.ilce_ilce_no_seq;
       public          postgres    false    219         �           0    0    ilce_ilce_no_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.ilce_ilce_no_seq OWNED BY public.ilce.ilce_no;
          public          postgres    false    218         �            1259    16694    iletisim_bilgileri    TABLE     �   CREATE TABLE public.iletisim_bilgileri (
    id integer NOT NULL,
    telefon integer NOT NULL,
    kisi_no integer,
    ilce integer NOT NULL,
    adres character varying NOT NULL
);
 &   DROP TABLE public.iletisim_bilgileri;
       public         heap    postgres    false         �            1259    16693    iletisim_bilgileri_id_seq    SEQUENCE     �   CREATE SEQUENCE public.iletisim_bilgileri_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.iletisim_bilgileri_id_seq;
       public          postgres    false    215         �           0    0    iletisim_bilgileri_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.iletisim_bilgileri_id_seq OWNED BY public.iletisim_bilgileri.id;
          public          postgres    false    214         �            1259    16832    kasa    TABLE     J   CREATE TABLE public.kasa (
    id integer NOT NULL,
    toplam integer
);
    DROP TABLE public.kasa;
       public         heap    postgres    false         �            1259    16831    kasa_id_seq    SEQUENCE     �   CREATE SEQUENCE public.kasa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.kasa_id_seq;
       public          postgres    false    227         �           0    0    kasa_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.kasa_id_seq OWNED BY public.kasa.id;
          public          postgres    false    226         �            1259    24672    kisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.kisi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.kisi_id_seq;
       public          postgres    false    232         �           0    0    kisi_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.kisi_id_seq OWNED BY public.kisi.id;
          public          postgres    false    231         �            1259    16809    odeme    TABLE     g   CREATE TABLE public.odeme (
    id integer NOT NULL,
    "kayıt_tarihi" date,
    uye_turu integer
);
    DROP TABLE public.odeme;
       public         heap    postgres    false         �            1259    16808    odeme_id_seq    SEQUENCE     �   CREATE SEQUENCE public.odeme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.odeme_id_seq;
       public          postgres    false    223         �           0    0    odeme_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.odeme_id_seq OWNED BY public.odeme.id;
          public          postgres    false    222         �            1259    24701    personel    TABLE     Z   CREATE TABLE public.personel (
    id integer,
    maas integer
)
INHERITS (public.kisi);
    DROP TABLE public.personel;
       public         heap    postgres    false    232         �            1259    24700    personel_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.personel_id_seq;
       public          postgres    false    234         �           0    0    personel_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.personel_id_seq OWNED BY public.personel.id;
          public          postgres    false    233         �            1259    24848    silinen_kisi    TABLE     d   CREATE TABLE public.silinen_kisi (
    ad character varying(40),
    soyad character varying(40)
);
     DROP TABLE public.silinen_kisi;
       public         heap    postgres    false         �            1259    16780    sporcu_bilgileri    TABLE     �   CREATE TABLE public.sporcu_bilgileri (
    id integer NOT NULL,
    boy integer,
    kilo integer,
    kol integer,
    "gogüs" integer,
    omuz integer,
    bel integer
);
 $   DROP TABLE public.sporcu_bilgileri;
       public         heap    postgres    false         �            1259    16779    sporcu_bilgileri_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sporcu_bilgileri_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sporcu_bilgileri_id_seq;
       public          postgres    false    221         �           0    0    sporcu_bilgileri_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.sporcu_bilgileri_id_seq OWNED BY public.sporcu_bilgileri.id;
          public          postgres    false    220         �            1259    16884    toplam_uye_sayisi    TABLE     B   CREATE TABLE public.toplam_uye_sayisi (
    toplam_uye integer
);
 %   DROP TABLE public.toplam_uye_sayisi;
       public         heap    postgres    false         �            1259    24818    uye    TABLE     s   CREATE TABLE public.uye (
    id integer DEFAULT nextval('public.kisi_id_seq'::regclass)
)
INHERITS (public.kisi);
    DROP TABLE public.uye;
       public         heap    postgres    false    231    232         �            1259    16852    uyelik_tipi    TABLE     X   CREATE TABLE public.uyelik_tipi (
    id integer NOT NULL,
    tip character varying
);
    DROP TABLE public.uyelik_tipi;
       public         heap    postgres    false         �           2604    16826    durum id    DEFAULT     d   ALTER TABLE ONLY public.durum ALTER COLUMN id SET DEFAULT nextval('public.durum_id_seq'::regclass);
 7   ALTER TABLE public.durum ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225         �           2604    24765 
   egitmen id    DEFAULT     h   ALTER TABLE ONLY public.egitmen ALTER COLUMN id SET DEFAULT nextval('public.egitmen_id_seq'::regclass);
 9   ALTER TABLE public.egitmen ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    236    236         �           2604    16733    il il_no    DEFAULT     d   ALTER TABLE ONLY public.il ALTER COLUMN il_no SET DEFAULT nextval('public.il_il_no_seq'::regclass);
 7   ALTER TABLE public.il ALTER COLUMN il_no DROP DEFAULT;
       public          postgres    false    217    216    217         �           2604    16747    ilce ilce_no    DEFAULT     l   ALTER TABLE ONLY public.ilce ALTER COLUMN ilce_no SET DEFAULT nextval('public.ilce_ilce_no_seq'::regclass);
 ;   ALTER TABLE public.ilce ALTER COLUMN ilce_no DROP DEFAULT;
       public          postgres    false    218    219    219         �           2604    16697    iletisim_bilgileri id    DEFAULT     ~   ALTER TABLE ONLY public.iletisim_bilgileri ALTER COLUMN id SET DEFAULT nextval('public.iletisim_bilgileri_id_seq'::regclass);
 D   ALTER TABLE public.iletisim_bilgileri ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    215    215         �           2604    16835    kasa id    DEFAULT     b   ALTER TABLE ONLY public.kasa ALTER COLUMN id SET DEFAULT nextval('public.kasa_id_seq'::regclass);
 6   ALTER TABLE public.kasa ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227         �           2604    24676    kisi id    DEFAULT     b   ALTER TABLE ONLY public.kisi ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);
 6   ALTER TABLE public.kisi ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231    232         �           2604    16812    odeme id    DEFAULT     d   ALTER TABLE ONLY public.odeme ALTER COLUMN id SET DEFAULT nextval('public.odeme_id_seq'::regclass);
 7   ALTER TABLE public.odeme ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    223    223         �           2604    24704    personel id    DEFAULT     j   ALTER TABLE ONLY public.personel ALTER COLUMN id SET DEFAULT nextval('public.personel_id_seq'::regclass);
 :   ALTER TABLE public.personel ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    234    234         �           2604    16783    sporcu_bilgileri id    DEFAULT     z   ALTER TABLE ONLY public.sporcu_bilgileri ALTER COLUMN id SET DEFAULT nextval('public.sporcu_bilgileri_id_seq'::regclass);
 B   ALTER TABLE public.sporcu_bilgileri ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220    221         �          0    24880    brans 
   TABLE DATA           4   COPY public.brans (brans_no, brans_adi) FROM stdin;
    public          postgres    false    239       3466.dat |          0    16823    durum 
   TABLE DATA           1   COPY public.durum (id, bitis_tarihi) FROM stdin;
    public          postgres    false    225       3452.dat �          0    24762    egitmen 
   TABLE DATA           X   COPY public.egitmen (id, ad, soyad, kisituru, dogum_tarihi, mail, brans_no) FROM stdin;
    public          postgres    false    236       3463.dat �          0    16870    fiyat 
   TABLE DATA           *   COPY public.fiyat (id, fiyat) FROM stdin;
    public          postgres    false    229       3456.dat t          0    16730    il 
   TABLE DATA           +   COPY public.il (il_no, il_adi) FROM stdin;
    public          postgres    false    217       3444.dat v          0    16744    ilce 
   TABLE DATA           5   COPY public.ilce (ilce_no, ilce_adi, il) FROM stdin;
    public          postgres    false    219       3446.dat r          0    16694    iletisim_bilgileri 
   TABLE DATA           O   COPY public.iletisim_bilgileri (id, telefon, kisi_no, ilce, adres) FROM stdin;
    public          postgres    false    215       3442.dat ~          0    16832    kasa 
   TABLE DATA           *   COPY public.kasa (id, toplam) FROM stdin;
    public          postgres    false    227       3454.dat �          0    24673    kisi 
   TABLE DATA           E   COPY public.kisi (id, ad, soyad, kisituru, dogum_tarihi) FROM stdin;
    public          postgres    false    232       3459.dat z          0    16809    odeme 
   TABLE DATA           >   COPY public.odeme (id, "kayıt_tarihi", uye_turu) FROM stdin;
    public          postgres    false    223       3450.dat �          0    24701    personel 
   TABLE DATA           O   COPY public.personel (id, ad, soyad, kisituru, dogum_tarihi, maas) FROM stdin;
    public          postgres    false    234       3461.dat �          0    24848    silinen_kisi 
   TABLE DATA           1   COPY public.silinen_kisi (ad, soyad) FROM stdin;
    public          postgres    false    238       3465.dat x          0    16780    sporcu_bilgileri 
   TABLE DATA           S   COPY public.sporcu_bilgileri (id, boy, kilo, kol, "gogüs", omuz, bel) FROM stdin;
    public          postgres    false    221       3448.dat �          0    16884    toplam_uye_sayisi 
   TABLE DATA           7   COPY public.toplam_uye_sayisi (toplam_uye) FROM stdin;
    public          postgres    false    230       3457.dat �          0    24818    uye 
   TABLE DATA           D   COPY public.uye (id, ad, soyad, kisituru, dogum_tarihi) FROM stdin;
    public          postgres    false    237       3464.dat           0    16852    uyelik_tipi 
   TABLE DATA           .   COPY public.uyelik_tipi (id, tip) FROM stdin;
    public          postgres    false    228       3455.dat �           0    0    durum_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.durum_id_seq', 1, false);
          public          postgres    false    224         �           0    0    egitmen_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.egitmen_id_seq', 13, true);
          public          postgres    false    235         �           0    0    il_il_no_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.il_il_no_seq', 1, true);
          public          postgres    false    216         �           0    0    ilce_ilce_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.ilce_ilce_no_seq', 6, true);
          public          postgres    false    218         �           0    0    iletisim_bilgileri_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.iletisim_bilgileri_id_seq', 76, true);
          public          postgres    false    214         �           0    0    kasa_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.kasa_id_seq', 1, false);
          public          postgres    false    226         �           0    0    kisi_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.kisi_id_seq', 39, true);
          public          postgres    false    231         �           0    0    odeme_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.odeme_id_seq', 1, false);
          public          postgres    false    222         �           0    0    personel_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.personel_id_seq', 103, true);
          public          postgres    false    233         �           0    0    sporcu_bilgileri_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.sporcu_bilgileri_id_seq', 1, true);
          public          postgres    false    220         �           2606    24884    brans brans_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.brans
    ADD CONSTRAINT brans_pkey PRIMARY KEY (brans_no);
 :   ALTER TABLE ONLY public.brans DROP CONSTRAINT brans_pkey;
       public            postgres    false    239         �           2606    16830    durum durum_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.durum
    ADD CONSTRAINT durum_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.durum DROP CONSTRAINT durum_pk;
       public            postgres    false    225         �           2606    24767    egitmen egitmenpk 
   CONSTRAINT     O   ALTER TABLE ONLY public.egitmen
    ADD CONSTRAINT egitmenpk PRIMARY KEY (id);
 ;   ALTER TABLE ONLY public.egitmen DROP CONSTRAINT egitmenpk;
       public            postgres    false    236         �           2606    16874    fiyat fiyat_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.fiyat
    ADD CONSTRAINT fiyat_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.fiyat DROP CONSTRAINT fiyat_pk;
       public            postgres    false    229         �           2606    16737    il il_pk 
   CONSTRAINT     I   ALTER TABLE ONLY public.il
    ADD CONSTRAINT il_pk PRIMARY KEY (il_no);
 2   ALTER TABLE ONLY public.il DROP CONSTRAINT il_pk;
       public            postgres    false    217         �           2606    16751    ilce ilce_pk 
   CONSTRAINT     O   ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pk PRIMARY KEY (ilce_no);
 6   ALTER TABLE ONLY public.ilce DROP CONSTRAINT ilce_pk;
       public            postgres    false    219         �           2606    16837    kasa kasa_pk 
   CONSTRAINT     J   ALTER TABLE ONLY public.kasa
    ADD CONSTRAINT kasa_pk PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.kasa DROP CONSTRAINT kasa_pk;
       public            postgres    false    227         �           2606    24678    kisi kisiPK 
   CONSTRAINT     K   ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT "kisiPK" PRIMARY KEY (id);
 7   ALTER TABLE ONLY public.kisi DROP CONSTRAINT "kisiPK";
       public            postgres    false    232         �           2606    16814    odeme odeme_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.odeme
    ADD CONSTRAINT odeme_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.odeme DROP CONSTRAINT odeme_pk;
       public            postgres    false    223         �           2606    24706    personel personelPK 
   CONSTRAINT     S   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT "personelPK" PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.personel DROP CONSTRAINT "personelPK";
       public            postgres    false    234         �           2606    16785     sporcu_bilgileri s.bilgileri_uye 
   CONSTRAINT     `   ALTER TABLE ONLY public.sporcu_bilgileri
    ADD CONSTRAINT "s.bilgileri_uye" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.sporcu_bilgileri DROP CONSTRAINT "s.bilgileri_uye";
       public            postgres    false    221         �           2606    16858    uyelik_tipi uyelik_tipi_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.uyelik_tipi
    ADD CONSTRAINT uyelik_tipi_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.uyelik_tipi DROP CONSTRAINT uyelik_tipi_pk;
       public            postgres    false    228         �           2606    24823 	   uye uyepk 
   CONSTRAINT     G   ALTER TABLE ONLY public.uye
    ADD CONSTRAINT uyepk PRIMARY KEY (id);
 3   ALTER TABLE ONLY public.uye DROP CONSTRAINT uyepk;
       public            postgres    false    237         �           2620    16916    odeme total_kasa    TRIGGER     k   CREATE TRIGGER total_kasa AFTER INSERT ON public.odeme FOR EACH ROW EXECUTE FUNCTION public.toplam_kasa();
 )   DROP TRIGGER total_kasa ON public.odeme;
       public          postgres    false    241    223         �           2620    24840    uye uye_sayisi_arttirma    TRIGGER     z   CREATE TRIGGER uye_sayisi_arttirma AFTER INSERT ON public.uye FOR EACH ROW EXECUTE FUNCTION public.uye_sayisi_arttirma();
 0   DROP TRIGGER uye_sayisi_arttirma ON public.uye;
       public          postgres    false    237    242         �           2620    24844    uye uye_sayisi_azaltma    TRIGGER     x   CREATE TRIGGER uye_sayisi_azaltma AFTER DELETE ON public.uye FOR EACH ROW EXECUTE FUNCTION public.uye_sayisi_azaltma();
 /   DROP TRIGGER uye_sayisi_azaltma ON public.uye;
       public          postgres    false    237    243         �           2620    24891    uye uye_yedekle    TRIGGER     h   CREATE TRIGGER uye_yedekle AFTER DELETE ON public.uye FOR EACH ROW EXECUTE FUNCTION public.yedekleme();
 (   DROP TRIGGER uye_yedekle ON public.uye;
       public          postgres    false    240    237         �           2606    24885    egitmen brans_egitmen    FK CONSTRAINT     �   ALTER TABLE ONLY public.egitmen
    ADD CONSTRAINT brans_egitmen FOREIGN KEY (brans_no) REFERENCES public.brans(brans_no) NOT VALID;
 ?   ALTER TABLE ONLY public.egitmen DROP CONSTRAINT brans_egitmen;
       public          postgres    false    236    3287    239         �           2606    16876    fiyat fiyat_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.fiyat
    ADD CONSTRAINT fiyat_id_fkey FOREIGN KEY (id) REFERENCES public.uyelik_tipi(id) NOT VALID;
 =   ALTER TABLE ONLY public.fiyat DROP CONSTRAINT fiyat_id_fkey;
       public          postgres    false    228    3275    229         �           2606    16752    ilce ilce_il_fkey    FK CONSTRAINT     u   ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_il_fkey FOREIGN KEY (il) REFERENCES public.il(il_no) NOT VALID;
 ;   ALTER TABLE ONLY public.ilce DROP CONSTRAINT ilce_il_fkey;
       public          postgres    false    219    217    3263         �           2606    16762 /   iletisim_bilgileri iletisim_bilgileri_ilce_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.iletisim_bilgileri
    ADD CONSTRAINT iletisim_bilgileri_ilce_fkey FOREIGN KEY (ilce) REFERENCES public.ilce(ilce_no) NOT VALID;
 Y   ALTER TABLE ONLY public.iletisim_bilgileri DROP CONSTRAINT iletisim_bilgileri_ilce_fkey;
       public          postgres    false    3265    215    219         �           2606    24824    iletisim_bilgileri iletisim_uye    FK CONSTRAINT     �   ALTER TABLE ONLY public.iletisim_bilgileri
    ADD CONSTRAINT iletisim_uye FOREIGN KEY (kisi_no) REFERENCES public.uye(id) NOT VALID;
 I   ALTER TABLE ONLY public.iletisim_bilgileri DROP CONSTRAINT iletisim_uye;
       public          postgres    false    3285    237    215         �           2606    24834 %   sporcu_bilgileri uye-sporcu_bilgileri    FK CONSTRAINT     �   ALTER TABLE ONLY public.sporcu_bilgileri
    ADD CONSTRAINT "uye-sporcu_bilgileri" FOREIGN KEY (id) REFERENCES public.uye(id) NOT VALID;
 Q   ALTER TABLE ONLY public.sporcu_bilgileri DROP CONSTRAINT "uye-sporcu_bilgileri";
       public          postgres    false    3285    221    237         �           2606    24829    odeme uye_odeme    FK CONSTRAINT     q   ALTER TABLE ONLY public.odeme
    ADD CONSTRAINT uye_odeme FOREIGN KEY (id) REFERENCES public.uye(id) NOT VALID;
 9   ALTER TABLE ONLY public.odeme DROP CONSTRAINT uye_odeme;
       public          postgres    false    237    223    3285                                                                                                                                                                                                                                                           3466.dat                                                                                            0000600 0004000 0002000 00000000040 14352315464 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Fitness
2	Yoga
3	Güreş
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                3452.dat                                                                                            0000600 0004000 0002000 00000000023 14352315464 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        39	2023-01-26
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             3463.dat                                                                                            0000600 0004000 0002000 00000000145 14352315464 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        11	Ömer	Aydın	egitmen	2022-12-25	omer_aydin@gmail.com	\N
13	Osman	Zeki	egitmen	2022-12-26	a	2
\.


                                                                                                                                                                                                                                                                                                                                                                                                                           3456.dat                                                                                            0000600 0004000 0002000 00000000021 14352315464 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        0	100
1	150
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               3444.dat                                                                                            0000600 0004000 0002000 00000000015 14352315464 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	UŞAK
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   3446.dat                                                                                            0000600 0004000 0002000 00000000113 14352315464 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Merkez	1
2	Banaz	1
3	Eşme	1
4	Ulubey	1
5	Sivaslı	1
6	Karahallı	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                     3442.dat                                                                                            0000600 0004000 0002000 00000000174 14352315464 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        67	457896	30	1	Akyazı
72	1	35	1	a
73	1	36	1	a
74	785496	37	1	Cumhuriyet Mahallesi
75	147856	38	1	Cumhuriyet Mahallesi
\.


                                                                                                                                                                                                                                                                                                                                                                                                    3454.dat                                                                                            0000600 0004000 0002000 00000000014 14352315464 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	5550
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    3459.dat                                                                                            0000600 0004000 0002000 00000000005 14352315464 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3450.dat                                                                                            0000600 0004000 0002000 00000000105 14352315464 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        35	2022-12-26	0
36	2022-12-26	0
37	2022-12-26	0
38	2022-12-26	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                           3461.dat                                                                                            0000600 0004000 0002000 00000000062 14352315464 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        103	Ahmet	Yılmaz	personel 	2022-12-25	15000
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                              3465.dat                                                                                            0000600 0004000 0002000 00000000776 14352315464 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \N	\N
\N	\N
\N	\N
\N	\N
Ahmet	Yılmaz
Ahmet	Yılmaz
Mustafa	Baran
Mustafa	Baran
Mustafa	Baran
Fatih	Örs
Ahmet	Yılmaz
Hakan	Bardak
Yasin	Dülger
Ramazan	Cesur
Ahmet	Şenol
Mustafa	Baran
Fatih	Örs
Ahmet	Yılmaz
Hakan	Bardak
Yasin	Dülger
Ramazan	Cesur
Ahmet	Şenol
Hakan	Kesgin
Yasin	Dülger
Ramazan	Cesur
Ahmet	Şenol
Hakan	Kesgin
Mustafa	Baran
Fatih	Örs
Ahmet	Yılmaz
Hakan	Bardak
Mustafa	Baran
Fatih	Örs
Ahmet	Yılmaz
Hakan	Bardak
Ramazan	Cesur
Ahmet	Şenol
Hakan	Kesgin
Yasin	Dülger
Ahmet 	Aktaş
\.


  3448.dat                                                                                            0000600 0004000 0002000 00000000052 14352315464 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        35	170	45	45	45	45	19
36	1	1	1	1	1	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      3457.dat                                                                                            0000600 0004000 0002000 00000000007 14352315464 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        6
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         3464.dat                                                                                            0000600 0004000 0002000 00000000551 14352315464 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        18	Mustafa	Baran	uye	2022-12-25
28	Fatih	Örs	uye	2022-12-25
29	Ahmet	Yılmaz	uye	2022-12-26
30	Hakan	Bardak	uye	2022-12-26
31	Yasin	Dülger	uye	2022-12-26
32	Ramazan	Cesur	uye	2022-12-26
33	Ahmet	Şenol	uye	2022-12-26
34	Hakan	Kesgin	uye	2022-12-26
35	a	a	uye	2022-12-26
36	a	a	uye	2003-06-20
37	Ahmet	Aktaş	uye	2022-12-26
38	Ahmet	Aktaş	uye	2022-12-26
\.


                                                                                                                                                       3455.dat                                                                                            0000600 0004000 0002000 00000000030 14352315464 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        0	ogrenci
1	normal
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        restore.sql                                                                                         0000600 0004000 0002000 00000057635 14352315464 0015413 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE gym;
--
-- Name: gym; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE gym WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Turkish_Turkey.1254';


ALTER DATABASE gym OWNER TO postgres;

\connect gym

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: eski_uyeler(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.eski_uyeler() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
	INSERT INTO silinen_kisi (ad ,soyad) values ( OLD.ad, OLD.soyad);
    RETURN NEW;
    END;
	$$;


ALTER FUNCTION public.eski_uyeler() OWNER TO postgres;

--
-- Name: kalorihesapla(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kalorihesapla(kisino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    personel RECORD;
    kg NUMERIC;
	kalori INTEGER;
BEGIN
    personel := uyeAra(kisino);
    kg := (SELECT kilo FROM sporcu_bilgileri WHERE id = kisino); 
	kalori:=kg*35;

    RETURN kalori;
END
$$;


ALTER FUNCTION public.kalorihesapla(kisino integer) OWNER TO postgres;

--
-- Name: proteinhesapla(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.proteinhesapla(kisino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    personel RECORD;
    kg NUMERIC;
	protein INTEGER;
BEGIN
    personel := uyeAra(kisino);
    kg := (SELECT kilo FROM sporcu_bilgileri WHERE id = kisino); 
	protein:=kg*2;

    RETURN protein;
END
$$;


ALTER FUNCTION public.proteinhesapla(kisino integer) OWNER TO postgres;

--
-- Name: toplam_kasa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplam_kasa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
	kisi_tipi integer;
 	BEGIN
		kisi_tipi:=(SELECT uye_turu FROM odeme ORDER BY id DESC limit 1);
		IF kisi_tipi!=0 THEN
			UPDATE kasa SET toplam=toplam+150;
			RETURN NEW;
		ELSE
			UPDATE kasa SET toplam=toplam+100;
			RETURN NEW;
		END IF;
  	END;
	$$;


ALTER FUNCTION public.toplam_kasa() OWNER TO postgres;

--
-- Name: uye_sayisi_arttirma(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uye_sayisi_arttirma() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
	UPDATE toplam_uye_sayisi set toplam_uye=toplam_uye + 1;
	RETURN NEW;
	END;
	$$;


ALTER FUNCTION public.uye_sayisi_arttirma() OWNER TO postgres;

--
-- Name: uye_sayisi_azaltma(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uye_sayisi_azaltma() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
	UPDATE toplam_uye_sayisi set toplam_uye=toplam_uye - 1;
	RETURN NEW;
	END;
	$$;


ALTER FUNCTION public.uye_sayisi_azaltma() OWNER TO postgres;

--
-- Name: uyeara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uyeara(numara integer) RETURNS TABLE(adi character varying, soyadi character varying, kisitipi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT ad,soyad,kisituru FROM uye
                 WHERE "id" = numara;
END;
$$;


ALTER FUNCTION public.uyeara(numara integer) OWNER TO postgres;

--
-- Name: yashesapla(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.yashesapla(kisino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    personel RECORD;
    dogumtarihi DATE;
	
BEGIN
    personel := uyeAra(kisino);
    dogumtarihi := (SELECT dogum_tarihi FROM uye WHERE id = kisino); 


    RETURN (SELECT DATE_PART('years', AGE(CURRENT_TIMESTAMP, dogumtarihi)));
END
$$;


ALTER FUNCTION public.yashesapla(kisino integer) OWNER TO postgres;

--
-- Name: yedekleme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.yedekleme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
  INSERT INTO "silinen_kisi" 
("ad", "soyad")
VALUES (OLD."ad",OLD."soyad");
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.yedekleme() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brans (
    brans_no integer NOT NULL,
    brans_adi character varying(40)
);


ALTER TABLE public.brans OWNER TO postgres;

--
-- Name: durum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.durum (
    id integer NOT NULL,
    bitis_tarihi date
);


ALTER TABLE public.durum OWNER TO postgres;

--
-- Name: durum_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.durum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.durum_id_seq OWNER TO postgres;

--
-- Name: durum_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.durum_id_seq OWNED BY public.durum.id;


--
-- Name: kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kisi (
    id integer NOT NULL,
    ad character varying(40) NOT NULL,
    soyad character varying(40) NOT NULL,
    kisituru character varying(40) NOT NULL,
    dogum_tarihi date NOT NULL
);


ALTER TABLE public.kisi OWNER TO postgres;

--
-- Name: egitmen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.egitmen (
    id integer,
    mail character varying(40),
    brans_no integer
)
INHERITS (public.kisi);


ALTER TABLE public.egitmen OWNER TO postgres;

--
-- Name: egitmen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.egitmen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.egitmen_id_seq OWNER TO postgres;

--
-- Name: egitmen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.egitmen_id_seq OWNED BY public.egitmen.id;


--
-- Name: fiyat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fiyat (
    id integer NOT NULL,
    fiyat integer
);


ALTER TABLE public.fiyat OWNER TO postgres;

--
-- Name: il; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.il (
    il_no integer NOT NULL,
    il_adi character varying NOT NULL
);


ALTER TABLE public.il OWNER TO postgres;

--
-- Name: il_il_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.il_il_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.il_il_no_seq OWNER TO postgres;

--
-- Name: il_il_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.il_il_no_seq OWNED BY public.il.il_no;


--
-- Name: ilce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilce (
    ilce_no integer NOT NULL,
    ilce_adi character varying,
    il integer
);


ALTER TABLE public.ilce OWNER TO postgres;

--
-- Name: ilce_ilce_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ilce_ilce_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ilce_ilce_no_seq OWNER TO postgres;

--
-- Name: ilce_ilce_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ilce_ilce_no_seq OWNED BY public.ilce.ilce_no;


--
-- Name: iletisim_bilgileri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.iletisim_bilgileri (
    id integer NOT NULL,
    telefon integer NOT NULL,
    kisi_no integer,
    ilce integer NOT NULL,
    adres character varying NOT NULL
);


ALTER TABLE public.iletisim_bilgileri OWNER TO postgres;

--
-- Name: iletisim_bilgileri_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.iletisim_bilgileri_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.iletisim_bilgileri_id_seq OWNER TO postgres;

--
-- Name: iletisim_bilgileri_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.iletisim_bilgileri_id_seq OWNED BY public.iletisim_bilgileri.id;


--
-- Name: kasa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kasa (
    id integer NOT NULL,
    toplam integer
);


ALTER TABLE public.kasa OWNER TO postgres;

--
-- Name: kasa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kasa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kasa_id_seq OWNER TO postgres;

--
-- Name: kasa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kasa_id_seq OWNED BY public.kasa.id;


--
-- Name: kisi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kisi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kisi_id_seq OWNER TO postgres;

--
-- Name: kisi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kisi_id_seq OWNED BY public.kisi.id;


--
-- Name: odeme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.odeme (
    id integer NOT NULL,
    "kayıt_tarihi" date,
    uye_turu integer
);


ALTER TABLE public.odeme OWNER TO postgres;

--
-- Name: odeme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.odeme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.odeme_id_seq OWNER TO postgres;

--
-- Name: odeme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.odeme_id_seq OWNED BY public.odeme.id;


--
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    id integer,
    maas integer
)
INHERITS (public.kisi);


ALTER TABLE public.personel OWNER TO postgres;

--
-- Name: personel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personel_id_seq OWNER TO postgres;

--
-- Name: personel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personel_id_seq OWNED BY public.personel.id;


--
-- Name: silinen_kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silinen_kisi (
    ad character varying(40),
    soyad character varying(40)
);


ALTER TABLE public.silinen_kisi OWNER TO postgres;

--
-- Name: sporcu_bilgileri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sporcu_bilgileri (
    id integer NOT NULL,
    boy integer,
    kilo integer,
    kol integer,
    "gogüs" integer,
    omuz integer,
    bel integer
);


ALTER TABLE public.sporcu_bilgileri OWNER TO postgres;

--
-- Name: sporcu_bilgileri_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sporcu_bilgileri_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sporcu_bilgileri_id_seq OWNER TO postgres;

--
-- Name: sporcu_bilgileri_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sporcu_bilgileri_id_seq OWNED BY public.sporcu_bilgileri.id;


--
-- Name: toplam_uye_sayisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplam_uye_sayisi (
    toplam_uye integer
);


ALTER TABLE public.toplam_uye_sayisi OWNER TO postgres;

--
-- Name: uye; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uye (
    id integer DEFAULT nextval('public.kisi_id_seq'::regclass)
)
INHERITS (public.kisi);


ALTER TABLE public.uye OWNER TO postgres;

--
-- Name: uyelik_tipi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uyelik_tipi (
    id integer NOT NULL,
    tip character varying
);


ALTER TABLE public.uyelik_tipi OWNER TO postgres;

--
-- Name: durum id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.durum ALTER COLUMN id SET DEFAULT nextval('public.durum_id_seq'::regclass);


--
-- Name: egitmen id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egitmen ALTER COLUMN id SET DEFAULT nextval('public.egitmen_id_seq'::regclass);


--
-- Name: il il_no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il ALTER COLUMN il_no SET DEFAULT nextval('public.il_il_no_seq'::regclass);


--
-- Name: ilce ilce_no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce ALTER COLUMN ilce_no SET DEFAULT nextval('public.ilce_ilce_no_seq'::regclass);


--
-- Name: iletisim_bilgileri id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iletisim_bilgileri ALTER COLUMN id SET DEFAULT nextval('public.iletisim_bilgileri_id_seq'::regclass);


--
-- Name: kasa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kasa ALTER COLUMN id SET DEFAULT nextval('public.kasa_id_seq'::regclass);


--
-- Name: kisi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi ALTER COLUMN id SET DEFAULT nextval('public.kisi_id_seq'::regclass);


--
-- Name: odeme id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odeme ALTER COLUMN id SET DEFAULT nextval('public.odeme_id_seq'::regclass);


--
-- Name: personel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel ALTER COLUMN id SET DEFAULT nextval('public.personel_id_seq'::regclass);


--
-- Name: sporcu_bilgileri id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sporcu_bilgileri ALTER COLUMN id SET DEFAULT nextval('public.sporcu_bilgileri_id_seq'::regclass);


--
-- Data for Name: brans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brans (brans_no, brans_adi) FROM stdin;
\.
COPY public.brans (brans_no, brans_adi) FROM '$$PATH$$/3466.dat';

--
-- Data for Name: durum; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.durum (id, bitis_tarihi) FROM stdin;
\.
COPY public.durum (id, bitis_tarihi) FROM '$$PATH$$/3452.dat';

--
-- Data for Name: egitmen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egitmen (id, ad, soyad, kisituru, dogum_tarihi, mail, brans_no) FROM stdin;
\.
COPY public.egitmen (id, ad, soyad, kisituru, dogum_tarihi, mail, brans_no) FROM '$$PATH$$/3463.dat';

--
-- Data for Name: fiyat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fiyat (id, fiyat) FROM stdin;
\.
COPY public.fiyat (id, fiyat) FROM '$$PATH$$/3456.dat';

--
-- Data for Name: il; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.il (il_no, il_adi) FROM stdin;
\.
COPY public.il (il_no, il_adi) FROM '$$PATH$$/3444.dat';

--
-- Data for Name: ilce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ilce (ilce_no, ilce_adi, il) FROM stdin;
\.
COPY public.ilce (ilce_no, ilce_adi, il) FROM '$$PATH$$/3446.dat';

--
-- Data for Name: iletisim_bilgileri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.iletisim_bilgileri (id, telefon, kisi_no, ilce, adres) FROM stdin;
\.
COPY public.iletisim_bilgileri (id, telefon, kisi_no, ilce, adres) FROM '$$PATH$$/3442.dat';

--
-- Data for Name: kasa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kasa (id, toplam) FROM stdin;
\.
COPY public.kasa (id, toplam) FROM '$$PATH$$/3454.dat';

--
-- Data for Name: kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kisi (id, ad, soyad, kisituru, dogum_tarihi) FROM stdin;
\.
COPY public.kisi (id, ad, soyad, kisituru, dogum_tarihi) FROM '$$PATH$$/3459.dat';

--
-- Data for Name: odeme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.odeme (id, "kayıt_tarihi", uye_turu) FROM stdin;
\.
COPY public.odeme (id, "kayıt_tarihi", uye_turu) FROM '$$PATH$$/3450.dat';

--
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personel (id, ad, soyad, kisituru, dogum_tarihi, maas) FROM stdin;
\.
COPY public.personel (id, ad, soyad, kisituru, dogum_tarihi, maas) FROM '$$PATH$$/3461.dat';

--
-- Data for Name: silinen_kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.silinen_kisi (ad, soyad) FROM stdin;
\.
COPY public.silinen_kisi (ad, soyad) FROM '$$PATH$$/3465.dat';

--
-- Data for Name: sporcu_bilgileri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sporcu_bilgileri (id, boy, kilo, kol, "gogüs", omuz, bel) FROM stdin;
\.
COPY public.sporcu_bilgileri (id, boy, kilo, kol, "gogüs", omuz, bel) FROM '$$PATH$$/3448.dat';

--
-- Data for Name: toplam_uye_sayisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toplam_uye_sayisi (toplam_uye) FROM stdin;
\.
COPY public.toplam_uye_sayisi (toplam_uye) FROM '$$PATH$$/3457.dat';

--
-- Data for Name: uye; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uye (id, ad, soyad, kisituru, dogum_tarihi) FROM stdin;
\.
COPY public.uye (id, ad, soyad, kisituru, dogum_tarihi) FROM '$$PATH$$/3464.dat';

--
-- Data for Name: uyelik_tipi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uyelik_tipi (id, tip) FROM stdin;
\.
COPY public.uyelik_tipi (id, tip) FROM '$$PATH$$/3455.dat';

--
-- Name: durum_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.durum_id_seq', 1, false);


--
-- Name: egitmen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.egitmen_id_seq', 13, true);


--
-- Name: il_il_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.il_il_no_seq', 1, true);


--
-- Name: ilce_ilce_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ilce_ilce_no_seq', 6, true);


--
-- Name: iletisim_bilgileri_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.iletisim_bilgileri_id_seq', 76, true);


--
-- Name: kasa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kasa_id_seq', 1, false);


--
-- Name: kisi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kisi_id_seq', 39, true);


--
-- Name: odeme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.odeme_id_seq', 1, false);


--
-- Name: personel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personel_id_seq', 103, true);


--
-- Name: sporcu_bilgileri_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sporcu_bilgileri_id_seq', 1, true);


--
-- Name: brans brans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brans
    ADD CONSTRAINT brans_pkey PRIMARY KEY (brans_no);


--
-- Name: durum durum_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.durum
    ADD CONSTRAINT durum_pk PRIMARY KEY (id);


--
-- Name: egitmen egitmenpk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egitmen
    ADD CONSTRAINT egitmenpk PRIMARY KEY (id);


--
-- Name: fiyat fiyat_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiyat
    ADD CONSTRAINT fiyat_pk PRIMARY KEY (id);


--
-- Name: il il_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il
    ADD CONSTRAINT il_pk PRIMARY KEY (il_no);


--
-- Name: ilce ilce_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pk PRIMARY KEY (ilce_no);


--
-- Name: kasa kasa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kasa
    ADD CONSTRAINT kasa_pk PRIMARY KEY (id);


--
-- Name: kisi kisiPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT "kisiPK" PRIMARY KEY (id);


--
-- Name: odeme odeme_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odeme
    ADD CONSTRAINT odeme_pk PRIMARY KEY (id);


--
-- Name: personel personelPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT "personelPK" PRIMARY KEY (id);


--
-- Name: sporcu_bilgileri s.bilgileri_uye; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sporcu_bilgileri
    ADD CONSTRAINT "s.bilgileri_uye" PRIMARY KEY (id);


--
-- Name: uyelik_tipi uyelik_tipi_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uyelik_tipi
    ADD CONSTRAINT uyelik_tipi_pk PRIMARY KEY (id);


--
-- Name: uye uyepk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uye
    ADD CONSTRAINT uyepk PRIMARY KEY (id);


--
-- Name: odeme total_kasa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER total_kasa AFTER INSERT ON public.odeme FOR EACH ROW EXECUTE FUNCTION public.toplam_kasa();


--
-- Name: uye uye_sayisi_arttirma; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER uye_sayisi_arttirma AFTER INSERT ON public.uye FOR EACH ROW EXECUTE FUNCTION public.uye_sayisi_arttirma();


--
-- Name: uye uye_sayisi_azaltma; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER uye_sayisi_azaltma AFTER DELETE ON public.uye FOR EACH ROW EXECUTE FUNCTION public.uye_sayisi_azaltma();


--
-- Name: uye uye_yedekle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER uye_yedekle AFTER DELETE ON public.uye FOR EACH ROW EXECUTE FUNCTION public.yedekleme();


--
-- Name: egitmen brans_egitmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egitmen
    ADD CONSTRAINT brans_egitmen FOREIGN KEY (brans_no) REFERENCES public.brans(brans_no) NOT VALID;


--
-- Name: fiyat fiyat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiyat
    ADD CONSTRAINT fiyat_id_fkey FOREIGN KEY (id) REFERENCES public.uyelik_tipi(id) NOT VALID;


--
-- Name: ilce ilce_il_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_il_fkey FOREIGN KEY (il) REFERENCES public.il(il_no) NOT VALID;


--
-- Name: iletisim_bilgileri iletisim_bilgileri_ilce_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iletisim_bilgileri
    ADD CONSTRAINT iletisim_bilgileri_ilce_fkey FOREIGN KEY (ilce) REFERENCES public.ilce(ilce_no) NOT VALID;


--
-- Name: iletisim_bilgileri iletisim_uye; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iletisim_bilgileri
    ADD CONSTRAINT iletisim_uye FOREIGN KEY (kisi_no) REFERENCES public.uye(id) NOT VALID;


--
-- Name: sporcu_bilgileri uye-sporcu_bilgileri; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sporcu_bilgileri
    ADD CONSTRAINT "uye-sporcu_bilgileri" FOREIGN KEY (id) REFERENCES public.uye(id) NOT VALID;


--
-- Name: odeme uye_odeme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odeme
    ADD CONSTRAINT uye_odeme FOREIGN KEY (id) REFERENCES public.uye(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   