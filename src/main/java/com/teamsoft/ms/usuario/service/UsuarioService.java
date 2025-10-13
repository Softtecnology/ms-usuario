package com.teamsoft.ms.usuario.service;

import com.teamsoft.ms.usuario.entities.Usuario;
import com.teamsoft.ms.usuario.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {
    
    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Usuario crearUsuario(Usuario usuario) {
        // Encriptar la contraseña antes de guardarla con encoder
        usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        return usuarioRepository.save(usuario);
    }

    public List<Usuario> obtenerTodosLosUsuarios() {
        return usuarioRepository.findAll();
    }

    public Optional<Usuario> obtenerUsuarioPorId(long id) {

        return usuarioRepository.findById(id);
    }

    public Optional<Usuario> getUserByEmail(String email) {

        return usuarioRepository.findByEmail(email);
    }

    public Optional<Usuario> actualizarUsuario(Long id, Usuario usuarioActualizado) {
        // 1. Buscar el usuario existente por ID
        Optional<Usuario> usuarioExistenteOpt = usuarioRepository.findById(id);

        if (usuarioExistenteOpt.isEmpty()) {
            // Si no se encuentra el usuario, retorna un Optional vacío
            return Optional.empty();
        }

        // 2. Obtener la instancia del usuario de la base de datos
        Usuario usuarioExistente = usuarioExistenteOpt.get();

        // 3. Actualizar los campos del usuario existente con los nuevos datos
        usuarioExistente.setRoleId(usuarioActualizado.getRoleId());
        usuarioExistente.setEmail(usuarioActualizado.getEmail());
        usuarioExistente.setCreationDate(usuarioActualizado.getCreationDate());
        usuarioExistente.setUpdateDate(usuarioActualizado.getUpdateDate());
        usuarioExistente.setStatus(usuarioActualizado.getStatus());

        // 4. Manejo especial para la contraseña: solo se actualiza si se proporciona una nueva
        if (usuarioActualizado.getPassword() != null && !usuarioActualizado.getPassword().isEmpty()) {
            usuarioExistente.setPassword(passwordEncoder.encode(usuarioActualizado.getPassword()));
        }

        // 5. Guardar el usuario actualizado en la base de datos
        Usuario usuarioGuardado = usuarioRepository.save(usuarioExistente);

        // 6. Retornar el usuario guardado envuelto en un Optional
        return Optional.of(usuarioGuardado);
    }


}
