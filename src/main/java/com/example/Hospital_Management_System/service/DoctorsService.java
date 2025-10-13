package com.example.Hospital_Management_System.service;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java. util.List;

public class DoctorsService {
    public void saveDoctors(Doctors doctor){
        Session session = null;
        Transaction tx=null;

        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx=session.beginTransaction();
            session.merge(doctor);
            tx.commit();
            System.out.println("Doctor saved :"+ doctor.getName());

        }catch(Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            System.err.println("Error saving the doctor :" + e.getMessage());
            e.printStackTrace();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    //READ
    public Doctors getDoctors(int id){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.get(Doctors.class,id);
        }catch(Exception e){
            System.err.println("Error retrieving Doctor with id:"+id+":"+e.getMessage());
            e.printStackTrace();
            return null;
        }finally {
            if(session!= null){
                session.close();
            }
        }
    }
    //READ ALL
    public List<Doctors>getAllDoctors(){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.createQuery("from Doctors",Doctors.class).list();

        }catch(Exception e){
            System.err.println("Error retrieving all doctors:"+e.getMessage());
            e.printStackTrace();
            return List.of();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void updateDoctor(Doctors doctor){
        Session session= null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(doctor);
            tx.commit();
            System.out.println("Doctor updated:"+ doctor.getName());
        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("Error updating student :"+ e.getMessage());
            e.printStackTrace();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void deleteDoctors(int id ){
        Session session= null;
        Transaction tx= null;

        try{
            session =HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            Doctors doctor= session.get(Doctors.class,id);
            if(doctor !=null){
                session.remove(doctor);
                System.out.println("Doctor deleted:"+doctor.getName());

            }else{
                System.out.println("Doctor with id"+id+ "not found");
            }
            tx.commit();

        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("error deleting doctor with id "+id+":"+e.getMessage());
            e.printStackTrace();
        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
}
